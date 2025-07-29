require 'rails_helper'

RSpec.describe "Sensors", type: :request do
  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }
  let(:sensor) { create(:sensor, user: user_1)}

  describe "GET #index" do
    context "when logged in" do
      before do
        login_as(user_1)
        get sensors_path
      end

      it { expect(response).to have_http_status(:success) }
    end
    context "when not logged in" do
      before do
        get sensors_path
      end

      it { expect(response).to have_http_status(:success) }
    end
  end

  describe "GET #show" do
    context "when logged in as the owner" do
      before do
        login_as(user_1)
        get sensor_path(sensor)
      end

      it { expect(response).to have_http_status(:success) }
    end

    context "when logged in as not the owner" do
      before do
        login_as(user_2)
        get sensor_path(sensor)
      end

      it { expect(response).to have_http_status(:success) }
    end

    context "when not logged in" do
      before do 
        get sensor_path(sensor)
      end

      it { expect(response).to have_http_status(:success) }
    end
  end

  describe "GET #new" do 
    context "when logged in" do
      before do
        login_as(user_1)
        get new_sensor_path
      end

      it { expect(response).to have_http_status(:success) }
    end

    context "when not logged in" do
      before do 
        get new_sensor_path
      end

      it { expect(response).to have_http_status(:redirect) }

      it "should redirect to the login page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST #create" do 
    context "when logged in" do
      before do
        login_as(user_1)
      end

      context "with valid params" do
        let(:valid_params) { attributes_for(:sensor) }

        before do
          post sensors_path, params: { sensor: valid_params }
        end

        it { expect(response).to have_http_status(:redirect) }

        it "should redirect to the sensor page" do
          expect(response).to redirect_to(sensor_path(Sensor.last))
        end
        
        it "should create a new sensor" do
          expect(Sensor.count).to eq(1)
        end

        it "should create the sensor with the correct attributes" do
          expect(Sensor.last.name).to eq(valid_params[:name])
          expect(Sensor.last.sender_id).to eq(valid_params[:sender_id])
          expect(Sensor.last.latitude).to eq(valid_params[:latitude])
          expect(Sensor.last.longitude).to eq(valid_params[:longitude])
        end
      end

      context "with invalid params" do
        before do
          post sensors_path, params: { sensor: { name: "", latitude: -200, longitude: 190, sender_id: "invalid" } }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }

        it "should not create a new sensor" do
          expect(Sensor.count).to eq(0)
        end
      end
    end

    context "when not logged in" do
      before do 
        post sensors_path, params: { sensor: attributes_for(:sensor) }
      end

      it { expect(response).to have_http_status(:redirect) }

      it "should redirect to the login page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #edit" do
    context "when logged in as the owner" do
      before do
        login_as(user_1)
        get edit_sensor_path(sensor)
      end

      it { expect(response).to have_http_status(:success) }
    end

    context "when logged in as not the owner" do
      before do
        login_as(user_2)
        get edit_sensor_path(sensor)
      end

      it { expect(response).to have_http_status(:redirect) }

      it "should redirect to the sensors page" do
        expect(response).to redirect_to(sensors_path)
      end
    end

    context "when not logged in" do
      before do 
        get edit_sensor_path(sensor)
      end

      it { expect(response).to have_http_status(:redirect) }

      it "should redirect to the login page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH #update" do
    context "when logged in as the owner" do
      before do
        login_as(user_1)
      end

      context "with valid attributes" do
        let(:valid_params) { attributes_for(:sensor) }

        before do
          patch sensor_path(sensor), params: { sensor: valid_params }
        end

        it { expect(response).to have_http_status(:redirect) }

        it "should redirect to the sensor page" do
          expect(response).to redirect_to(sensor_path(sensor))
        end

        it "should update the sensor" do
          expect(Sensor.last.name).to eq(valid_params[:name])
          expect(Sensor.last.sender_id).to eq(valid_params[:sender_id])
          expect(Sensor.last.latitude).to eq(valid_params[:latitude])
          expect(Sensor.last.longitude).to eq(valid_params[:longitude])
        end
      end

      context "with invalid attributes" do
        before do
          patch sensor_path(sensor), params: { sensor: { name: "", latitude: -200, longitude: 190, sender_id: "invalid" } }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }

        it "should not update the sensor" do
          expect(Sensor.last.name).to eq(sensor.name)
          expect(Sensor.last.sender_id).to eq(sensor.sender_id)
          expect(Sensor.last.latitude).to eq(sensor.latitude)
          expect(Sensor.last.longitude).to eq(sensor.longitude)
        end
      end
    end

    context "when logged in as not the owner" do
      before do
        login_as(user_2)
        patch sensor_path(sensor), params: { sensor: attributes_for(:sensor) }
      end

      it { expect(response).to have_http_status(:redirect) }

      it "should redirect to the sensors page" do
        expect(response).to redirect_to(sensors_path)
      end

      it "should not update the sensor" do
        expect(Sensor.last.name).to eq(sensor.name)
        expect(Sensor.last.sender_id).to eq(sensor.sender_id)
        expect(Sensor.last.latitude).to eq(sensor.latitude)
        expect(Sensor.last.longitude).to eq(sensor.longitude)
      end
    end

    context "when not logged in" do
      before do
        patch sensor_path(sensor), params: { sensor: attributes_for(:sensor) }
      end

      it { expect(response).to have_http_status(:redirect) }

      it "should redirect to the login page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when logged in as the owner" do
      before do
        login_as(user_1)
        delete sensor_path(sensor)
      end
      
      it { expect(response).to have_http_status(:redirect) }

      it "should delete the sensor" do
        expect(Sensor.count).to eq(0)
      end
    end

    context "when logged in as not the owner" do
      before do
        login_as(user_2)
        delete sensor_path(sensor)
      end

      it { expect(response).to have_http_status(:redirect) }

      it "should redirect to the sensors page" do
        expect(response).to redirect_to(sensors_path)
      end

      it "should not delete the sensor" do
        expect(Sensor.count).to eq(1) 
      end
    end

    context "when not logged in" do
      before do
        delete sensor_path(sensor)
      end

      it { expect(response).to have_http_status(:redirect) }

      it "should redirect to the login page" do
        expect(response).to redirect_to(new_user_session_path)
      end

      it "should not delete the sensor" do
        expect(Sensor.count).to eq(1) 
      end
    end
  end
end
