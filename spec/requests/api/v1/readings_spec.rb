require 'rails_helper'

RSpec.describe "Api::V1::Readings", type: :request do
  SECRET_KEY = Rails.application.credentials.mqtt_broker[:shared_secret]

  before do
    host! "api.example.com"
  end

  describe "POST /create" do
    let!(:sensor) { create(:sensor) }
    let(:valid_attributes) { attributes_for(:reading) }

    context "with valid parameters" do
      before do 
        post api_v1_create_readings_path(sensor.sender_id), params: { reading: valid_attributes }, headers: { "X-Auth-Token" => SECRET_KEY }
      end

      it "creates a new Reading" do
        expect(Reading.count).to eq(1)
      end

      it "returns HTTP created" do
        expect(response).to have_http_status(:created)
      end

      it "returns the created reading" do
        json = JSON.parse(response.body)
        expect(json["pm25"]).to eq(valid_attributes[:pm25])
        expect(json["pm10"]).to eq(valid_attributes[:pm10])
        expect(json["pm100"]).to eq(valid_attributes[:pm100])
        expect(json["co2"]).to eq(valid_attributes[:co2])
        expect(json["temperature"]).to eq(valid_attributes[:temperature])
        expect(json["relative_humidity"]).to eq(valid_attributes[:relative_humidity])
        expect(Time.parse(json["timestamp"])).to be_within(1.second).of(valid_attributes[:timestamp])
        expect(json["battery_level"]).to eq(valid_attributes[:battery_level])
      end
    end

    context "without auth token" do
      before do 
        post api_v1_create_readings_path(sensor.sender_id), params: { reading: valid_attributes }
      end

      it "does not create a new Reading" do
        expect(Reading.count).to eq(0)
      end

      it "returns HTTP unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid auth token" do
      before do 
        post api_v1_create_readings_path(sensor.sender_id), params: { reading: valid_attributes }, headers: { "X-Auth-Token" => "invalid" }
      end

      it "does not create a new Reading" do
        expect(Reading.count).to eq(0)
      end

      it "returns HTTP unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid sender id" do
      before do 
        post api_v1_create_readings_path("invalid"), params: { reading: valid_attributes }, headers: { "X-Auth-Token" => SECRET_KEY }
      end

      it "does not create a new Reading" do
        expect(Reading.count).to eq(0)
      end

      it "returns HTTP unauthorized" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end