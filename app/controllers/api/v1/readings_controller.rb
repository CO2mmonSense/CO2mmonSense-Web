class Api::V1::ReadingsController < Api::BaseController
    SHARED_SECRET = Rails.application.credentials.mqtt_broker[:shared_secret]

    before_action :authenticate_with_shared_secret!, only: :create
    before_action :authenticate_api_key!, only: :index

    DEFAULT_MAX = 100
    MAX_MAX     = 500

    def create
        sensor = Sensor.find_by!(sender_id: params[:sender_id])
        reading = sensor.readings.build(reading_params)

        if reading.save
            render json: reading.as_json(except: [:sensor_id, :created_at, :updated_at]), status: :created
        else
            render json: { errors: reading.errors }, status: :unprocessable_entity
        end
    end

    def index
        sensor = Sensor.find(params[:sensor_id])

        start_at = parse_time(params[:start_at]) || 24.hours.ago
        end_at = parse_time(params[:end_at]) || Time.current
        end_at = Time.current if end_at > Time.current

        max = params[:max].to_i
        max = DEFAULT_MAX if max <= 0
        max = [max, MAX_MAX].max < 1 ? 1 : [max, MAX_MAX].min

        scope = sensor.readings.where(timestamp: start_at..end_at)

        if (bucket = params[:bucket]).present?
        interval = parse_interval(bucket)
        interval_sec = interval_seconds(interval)

        relation = scope
            .select(<<~SQL)
            to_timestamp(
                (EXTRACT(EPOCH FROM timestamp)::bigint / #{interval_sec}) * #{interval_sec}
            ) AS bucket_ts,
            AVG(pm25)              AS pm25,
            AVG(pm10)              AS pm10,
            AVG(pm100)             AS pm100,
            AVG(co2)               AS co2,
            AVG(temperature)       AS temperature,
            AVG(relative_humidity) AS relative_humidity,
            AVG(battery_level)     AS battery_level
            SQL
            .group("bucket_ts")
            .order("bucket_ts ASC")
            .limit(max)

        rows = relation.map do |row|
            {
            timestamp:          row.bucket_ts.as_json,
            pm25:               row.pm25&.to_f,
            pm10:               row.pm10&.to_f,
            pm100:              row.pm100&.to_f,
            co2:                row.co2&.to_f,
            temperature:        row.temperature&.to_f,
            relative_humidity:  row.relative_humidity&.to_f,
            battery_level:      row.battery_level&.to_i
            }
        end

        render json: { data: rows }
            return
        end

        sql = <<~SQL
        WITH base AS (
            SELECT
            id, sensor_id, timestamp, pm25, pm10, pm100, co2, temperature, relative_humidity, battery_level,
            ntile(#{max}) OVER (ORDER BY timestamp ASC, id ASC) AS bucket
            FROM readings
            WHERE sensor_id = :sensor_id
            AND timestamp BETWEEN :start_at AND :end_at
        ),
        sampled AS (
            SELECT
            id, sensor_id, timestamp, pm25, pm10, pm100, co2, temperature, relative_humidity, battery_level,
            row_number() OVER (PARTITION BY bucket ORDER BY timestamp ASC, id ASC) AS rn
            FROM base
        )
        SELECT
            id, timestamp, pm25, pm10, pm100, co2, temperature, relative_humidity, battery_level
        FROM sampled
        WHERE rn = 1
        ORDER BY timestamp ASC, id ASC
        SQL

        binds = {
        sensor_id: sensor.id,
        start_at:  start_at,
        end_at:    end_at
        }

        # Use sanitize_sql_array to safely interpolate named binds.
        sanitized = ActiveRecord::Base.send(:sanitize_sql_array, [sql, binds])
        rows = Reading.find_by_sql(sanitized).map do |r|
        {
            "id"                 => r.id,
            "timestamp"          => r.timestamp.as_json,
            "pm25"               => r.pm25,
            "pm10"               => r.pm10,
            "pm100"              => r.pm100,
            "co2"                => r.co2,
            "temperature"        => r.temperature,
            "relative_humidity"  => r.relative_humidity,
            "battery_level"      => r.battery_level
        }
        end

        render json: rows
    end

    private

    def reading_params
        params.require(:reading).permit(:pm25, :pm10, :pm100, :co2, :relative_humidity, :temperature, :battery_level, :timestamp)
    end

    def authenticate_with_shared_secret!
        header = request.headers['Authorization']
        provided_token = header.split(' ').last if header

        unless ActiveSupport::SecurityUtils.secure_compare(provided_token.to_s, SHARED_SECRET)
        render json: { error: "Unauthorized" }, status: :unauthorized
        end
    end

    def parse_time(s)
        Time.iso8601(s) rescue nil
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