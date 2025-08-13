class Api::V1::ReadingsController < Api::BaseController
    # Secret used to authenticate POST requests from the broker/hardware.
    SHARED_SECRET = Rails.application.credentials.mqtt_broker[:shared_secret]

    before_action :authenticate_with_shared_secret!, only: :create
    before_action :authenticate_api_key!, only: :index

    # Constants for query pagination and limits.
    MAX_LIMIT = 10_000
    DEFAULT_LIMIT = 1_000

    # POST /api/v1/readings
    # Creates a new reading for a sensor. Authenticated via a shared secret.
    def create
        sensor = Sensor.find_by!(sender_id: params[:sender_id])
        reading = sensor.readings.build(reading_params)

        if reading.save
            render json: reading.as_json(except: [:sensor_id, :created_at, :updated_at]), status: :created
        else
            render json: { errors: reading.errors }, status: :unprocessable_entity
        end
    end

    # GET /api/v1/sensors/:sensor_id/readings
    # Retrieves readings for a sensor with filtering, pagination, downsampling, and thinning.
    def index
        sensor = Sensor.find(params[:sensor_id])

        start_at = parse_time(params[:start_at]) || 24.hours.ago
        end_at   = parse_time(params[:end_at])   || Time.current
        end_at   = Time.current if end_at > Time.current

        # Enforce a limit between 1 and MAX_LIMIT, using DEFAULT_LIMIT if none is provided.
        limit = params[:limit].to_i
        limit = DEFAULT_LIMIT if limit <= 0
        limit = [limit, MAX_LIMIT].min

        before_ts, before_id = parse_cursor(params[:before])
        after_ts,  after_id  = parse_cursor(params[:after])

        scope = sensor.readings.where(timestamp: start_at..end_at)

        # Keyset pagination (seek method) for efficient scrolling through raw data.
        # NOTE: The (timestamp, id) syntax for row-value comparison is specific to PostgreSQL.
        if before_ts && before_id
            scope = scope.where("(timestamp, id) < (?, ?)", before_ts, before_id)
        end

        if after_ts && after_id
            scope = scope.where("(timestamp, id) > (?, ?)", after_ts, after_id)
        end

        # --- Data Aggregation (Downsampling) Path ---
        if (bucket = params[:bucket]).present?
            interval = parse_interval(bucket)
            interval_sec = interval_seconds(interval)

            # SECURITY NOTE: The `interval_sec` is interpolated into the SQL string.
            # This is safe ONLY because `parse_interval` uses a strict regex to extract digits,
            # preventing SQL injection. Do not relax this validation.
            #
            # This query groups readings into time buckets (e.g., 5-minute, 1-hour) and
            # calculates the average value for each sensor metric within that bucket.
            relation = scope
                .select(<<~SQL)
                    to_timestamp(
                        (EXTRACT(EPOCH FROM timestamp)::bigint / #{interval_sec}) * #{interval_sec}
                    ) AS bucket_ts,
                    AVG(pm25) AS pm25,
                    AVG(pm10) AS pm10,
                    AVG(pm100) AS pm100,
                    AVG(co2) AS co2,
                    AVG(temperature) AS temperature,
                    AVG(relative_humidity) AS relative_humidity,
                    AVG(battery_level) AS battery_level
                SQL
                .group("bucket_ts")
                .order("bucket_ts DESC")
                .limit(limit)

            # Manually build response hash. Note that types might need casting from BigDecimal.
            rows = relation.map do |row|
                {
                    timestamp: row.bucket_ts.as_json,
                    pm25: row.pm25&.to_f,
                    pm10: row.pm10&.to_f,
                    pm100: row.pm100&.to_f,
                    co2: row.co2&.to_f,
                    temperature: row.temperature&.to_f,
                    relative_humidity: row.relative_humidity&.to_f,
                    battery_level: row.battery_level&.to_i
                }
            end

            # Aggregated data is not paginated with a cursor, as the concept of a unique 'id'
            # for the next page doesn't exist. The client receives the complete aggregated set.
            render json: { data: rows }
            return
        end

        # --- Data Thinning Path ---
        if (every_n = params[:every_n].to_i) >= 2
            # Cheaply samples data by keeping only the first reading of every N-minute interval.
            # This is deterministic and index-friendly.
            # NOTE: This `EXTRACT(EPOCH ...)` syntax is most compatible with PostgreSQL.
            scope = scope.where("(EXTRACT(EPOCH FROM timestamp)::bigint / 60) % ? = 0", every_n)
        end

        # --- Standard Raw Data Path ---
        # Order must match the direction of the keyset pagination (<)
        scope = scope
            .order(timestamp: :desc, id: :desc)
            .limit(limit)

        # Use `as_json` for fast serialization without instantiating full ActiveRecord objects.
        rows = scope.as_json(except: [:sensor_id, :created_at, :updated_at])

        # Generate the cursor for the next page from the last record in the current set.
        next_cursor = if rows.any?
            cursor_from(rows.last['timestamp'], rows.last['id'])
        end

        render json: { data: rows, next_before: next_cursor }
    end

    private

    def reading_params
        params.require(:reading).permit(:pm25, :pm10, :pm100, :co2, :relative_humidity, :temperature, :battery_level, :timestamp)
    end

    def authenticate_with_shared_secret!
        header = request.headers['Authorization']
        provided_token = header.split(' ').last if header

        # Use secure_compare to prevent timing attacks.
        unless ActiveSupport::SecurityUtils.secure_compare(provided_token.to_s, SHARED_SECRET)
            render json: { error: "Unauthorized" }, status: :unauthorized
        end
    end

    def parse_time(s)
        Time.iso8601(s) rescue nil
    end

    # Parses a cursor string into a timestamp and an ID. e.g., "2025-08-13T17:30:00.000Z,12345"
    def parse_cursor(s)
        return [nil, nil] if s.blank?
        ts_str, id_str = s.split(",", 2)
        [parse_time(ts_str), id_str&.to_i]
    end

    # Generates a cursor string from a timestamp and an ID.
    def cursor_from(ts, id)
        "#{Time.parse(ts.to_s).utc.iso8601(3)},#{id}"
    end

    # Parses a bucket interval string (e.g., "5m", "1h") into a SQL interval string.
    def parse_interval(s)
        case s
        when /\A(\d+)m\z/ then "#{$1} minutes"
        when /\A(\d+)h\z/ then "#{$1} hours"
        when /\A(\d+)d\z/ then "#{$1} days"
        else "1 hour" # Default bucket size
        end
    end

    # Converts a SQL interval string into a total number of seconds.
    def interval_seconds(interval_str)
        n, unit = interval_str.split
        n = n.to_i
        case unit
        when "minute", "minutes" then n * 60
        when "hour", "hours"     then n * 3600
        when "day", "days"       then n * 86_400
        else 3600 # Default to 1 hour
        end
    end
end