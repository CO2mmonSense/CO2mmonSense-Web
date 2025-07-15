class Api::V1::ReadingsController < ActionController::API
    SECRET_KEY = Rails.application.credentials.mqtt_broker[:shared_secret]
    
    before_action :authenticate_with_shared_secret!

    def create
        sensor = Sensor.find_by!(sender_id: params[:sender_id])
        reading = sensor.readings.build(reading_params)

        if reading.save
            render json: reading, status: :created
        else
            render json: reading.errors, status: :unprocessable_entity
        end
    end

    private 

    def reading_params
        params.require(:reading).permit(:pm25, :pm10, :pm100, :co2, :relative_humidity, :temperature, :battery_level, :timestamp)
    end

    def authenticate_with_shared_secret!
        provided_secret = request.headers["X-Auth-Token"]

        unless ActiveSupport::SecurityUtils.secure_compare(provided_secret.to_s, SECRET_KEY)
            render json: { error: "Unauthorized" }, status: :unauthorized
        end
    end
end
