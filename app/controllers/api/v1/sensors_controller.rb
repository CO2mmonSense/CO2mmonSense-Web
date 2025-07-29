class Api::V1::SensorsController < Api::BaseController
    before_action :authenticate_api_key!

    def index
        sensors = Sensor.includes(:latest_reading).all
        render json: sensors.map { |sensor| sensor_json(sensor) }
    end

    def show
        sensor = Sensor.includes(:latest_reading).find(params[:id])
        render json: sensor_json(sensor)
    end

    private 

    def sensor_json(sensor)
        sensor.as_json(only: [:id, :name, :sender_id]).merge(
            latitude: sensor.latitude,
            longitude: sensor.longitude,
            latest_reading: sensor.latest_reading.as_json(only: [ :pm25, :pm10, :pm100, :co2, :temperature, :relative_humidity, :battery_level, :timestamp ])
        )
    end
end
