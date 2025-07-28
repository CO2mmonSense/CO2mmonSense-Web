class Api::V1::ReadingsController < ActionController::API
    SHARED_SECRET = Rails.application.credentials.mqtt_broker[:shared_secret]
    
    before_action :authenticate_with_shared_secret!, only: :create

    def create
        sensor = Sensor.find_by!(sender_id: params[:sender_id])
        reading = sensor.readings.build(reading_params)

        if reading.save
            render json: reading, status: :created
        else
            render json: reading.errors, status: :unprocessable_entity
        end
    end

    def index
        sensor = Sensor.find(params[:sensor_id])
        readings = sensor.readings

        render json: readings.map { |reading| reading.as_json(only: [:timestamp, :pm25, :pm10, :pm100, :co2, :relative_humidity, :temperature, :battery_level]) }
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
end
