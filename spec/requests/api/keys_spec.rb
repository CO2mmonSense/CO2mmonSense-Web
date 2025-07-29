require 'rails_helper'

RSpec.describe "Api::Keys", type: :request do
  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }
  let(:api_key) { create(:api_key, bearer: user_1)}

  describe "GET #index" do
    context "when logged in" do
      before do
        login_as(user_1)
        get api_keys_path
      end

      it { expect(response).to have_http_status(:success) }
    end
    context "when not logged in" do
      before do
        get api_keys_path
      end

      it { expect(response).to have_http_status(:redirect) }

      it "should redirect to the login page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #new" do 
    context "when logged in" do
      before do
        login_as(user_1)
        get new_api_key_path
      end

      it { expect(response).to have_http_status(:success) }
    end

    context "when not logged in" do
      before do 
        get new_api_key_path
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
        post api_keys_path, params: { api_key: { name: "Test Key" }  }
      end

      it { expect(response).to have_http_status(:redirect) }

      it "should redirect to the api key page" do
        expect(response).to redirect_to(api_keys_path)
      end
      
      it "should create a new api key" do
        expect(ApiKey.count).to eq(1)
      end
    end

    context "when not logged in" do
      before do 
        post api_keys_path, params: { api_key: { name: "Test Key" }  }
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
        get edit_api_key_path(api_key)
      end

      it { expect(response).to have_http_status(:success) }
    end

    context "when logged in as not the owner" do
      before do
        login_as(user_2)
        get edit_api_key_path(api_key)
      end

      it { expect(response).to have_http_status(:redirect) }

      it "should redirect to the api keys page" do
        expect(response).to redirect_to(api_keys_path)
      end
    end

    context "when not logged in" do
      before do 
        get edit_api_key_path(api_key)
      end

      it { expect(response).to have_http_status(:redirect) }

      it "should redirect to the login page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH #update" do
    let(:valid_params) { attributes_for(:api_key) }

    context "when logged in as the owner" do
      before do
        login_as(user_1)
        patch api_key_path(api_key), params: { api_key: valid_params }
      end

      it { expect(response).to have_http_status(:redirect) }

      it "should redirect to the api key page" do
        expect(response).to redirect_to(api_keys_path)
      end

      it "should update the api key" do
        expect(ApiKey.last.name).to eq(valid_params[:name])
      end
    end

    context "when logged in as not the owner" do
      before do
        login_as(user_2)
        patch api_key_path(api_key), params: { api_key: valid_params }
      end

      it { expect(response).to have_http_status(:redirect) }

      it "should redirect to the api keys page" do
        expect(response).to redirect_to(api_keys_path)
      end

      it "should not update the api key" do
        expect(ApiKey.last.name).to eq(api_key.name)
      end
    end

    context "when not logged in" do
      before do
        patch api_key_path(api_key), params: { api_key: valid_params }
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
        delete api_key_path(api_key)
      end
      
      it { expect(response).to have_http_status(:redirect) }

      it "should delete the api key" do
        expect(ApiKey.count).to eq(0)
      end
    end

    context "when logged in as not the owner" do
      before do
        login_as(user_2)
        delete api_key_path(api_key)
      end

      it { expect(response).to have_http_status(:redirect) }

      it "should redirect to the api keys page" do
        expect(response).to redirect_to(api_keys_path)
      end

      it "should not delete the api key" do
        expect(ApiKey.count).to eq(1) 
      end
    end

    context "when not logged in" do
      before do
        delete api_key_path(api_key)
      end

      it { expect(response).to have_http_status(:redirect) }

      it "should redirect to the login page" do
        expect(response).to redirect_to(new_user_session_path)
      end

      it "should not delete the api key" do
        expect(ApiKey.count).to eq(1) 
      end
    end
  end
end
