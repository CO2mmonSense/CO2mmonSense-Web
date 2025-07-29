require 'rails_helper'

RSpec.describe "Api::Documentation", type: :request do
  describe "GET /index" do
    before do
      get api_documentation_path
    end

    it "returns http success" do
        expect(response).to have_http_status(:success)
    end
  end
end
