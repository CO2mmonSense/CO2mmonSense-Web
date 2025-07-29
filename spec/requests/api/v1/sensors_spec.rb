require 'rails_helper'

RSpec.describe "Api::V1::Sensors", type: :request do
    let(:api_key) { create(:api_key) }

    before do
        host! "api.example.com"
    end
    
    describe "GET /index" do
        let!(:sensor_1) { create(:sensor) }
        let!(:sensor_2) { create(:sensor) }
        let!(:sensor_3) { create(:sensor) }
        let!(:reading_1_1) { create(:reading, timestamp: Date.new(2025, 5, 20), sensor: sensor_1) }
        let!(:reading_1_2) { create(:reading, timestamp: Date.new(2025, 5, 21), sensor: sensor_1) }
        let!(:reading_2) { create(:reading, timestamp: Date.new(2025, 5, 22), sensor: sensor_2) }

        before do
            get api_v1_sensors_path, headers: { "Authorization" => "Bearer #{api_key.raw_token}" }
        end

        it "returns all sensors" do
            json = JSON.parse(response.body)
            expect(json.size).to eq(3)
        end

        it "returns http success" do
            expect(response).to have_http_status(:success)
        end

        context "without api key" do
            before do 
                get api_v1_sensors_path
            end

            it "returns HTTP unauthorized" do
                expect(response).to have_http_status(:unauthorized)
            end
        end
            
        context "with an invalid api key" do
            before do 
                get api_v1_sensors_path, headers: { "Authorization" => "invalid" }
            end
            
            it "returns HTTP unauthorized" do
                expect(response).to have_http_status(:unauthorized)
            end
        end
    end

    describe "GET /show" do
        let!(:sensor) { create(:sensor) }
        let!(:reading_1) { create(:reading, timestamp: Date.new(2025, 5, 20), sensor: sensor) }
        let!(:reading_2) { create(:reading, timestamp: Date.new(2025, 5, 21), sensor: sensor) }

        context "with a valid id" do
            before do
                get api_v1_sensor_path(sensor.id), headers: { "Authorization" => "Bearer #{api_key.raw_token}" }
            end

            it "returns the sensor" do
                json = JSON.parse(response.body)
                expect(json["name"]).to eq(sensor.name)
                expect(json["sender_id"]).to eq(sensor.sender_id)
                expect(json["longitude"]).to eq(sensor.longitude)
                expect(json["latitude"]).to eq(sensor.latitude)
                expect(json["latest_reading"]["pm25"]).to eq(reading_2.pm25)
                expect(json["latest_reading"]["pm10"]).to eq(reading_2.pm10)
                expect(json["latest_reading"]["pm100"]).to eq(reading_2.pm100)
                expect(json["latest_reading"]["temperature"]).to eq(reading_2.temperature)
                expect(json["latest_reading"]["relative_humidity"]).to eq(reading_2.relative_humidity)
                expect(json["latest_reading"]["battery_level"]).to eq(reading_2.battery_level)
                expect(Time.parse(json["latest_reading"]["timestamp"])).to be_within(1.second).of(reading_2.timestamp)
            end

            it "returns http success" do
                expect(response).to have_http_status(:success)
            end
        end

        context "with an invalid id" do
            before do
                get api_v1_sensor_path("invalid"), headers: { "Authorization" => "Bearer #{api_key.raw_token}" }
            end

            it "returns http not found" do
                expect(response).to have_http_status(:not_found)
            end
        end

        context "without api key" do
            before do 
                get api_v1_sensor_path(sensor.id)
            end

            it "returns HTTP unauthorized" do
                expect(response).to have_http_status(:unauthorized)
            end
        end
            
        context "with an invalid api key" do
            before do 
                get api_v1_sensor_path(sensor.id), headers: { "Authorization" => "invalid" }
            end
            
            it "returns HTTP unauthorized" do
                expect(response).to have_http_status(:unauthorized)
            end
        end
    end
end
