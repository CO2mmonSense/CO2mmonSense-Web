class SensorsController < ApplicationController
    before_action :set_sensor, except: [:index, :new, :create]
    before_action :authenticate_user!, except: [:index, :show]
    before_action :authorize_user!, only: [:edit, :update, :destroy]

    def index
        @sensors = Sensor.all
    end

    def show
    end

    def new
        @sensor = current_user.sensors.build
    end

    def create
        @sensor = current_user.sensors.build(sensor_params)
        if @sensor.save
            redirect_to sensor_path(@sensor), notice: 'Sensor was successfully created.'
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @sensor.update(sensor_params)
            redirect_to sensor_path(@sensor), notice: 'Sensor was successfully updated.'
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        if @sensor.destroy
            redirect_to sensors_path, notice: "Sensor deleted successfully."
        else
            redirect_to sensor_path(@sensor), alert: "Unable to delete sensor."
        end
    end

    private 

    def set_sensor
        @sensor = Sensor.find(params[:id])
    end

    def authorize_user!
        unless @sensor.user == current_user
            redirect_to sensors_path, alert: "You are not authorized to perform this action."
        end
    end

    def sensor_params
        params.require(:sensor).permit(:name, :sender_id, :latitude, :longitude)
    end
end
