require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  let(:bearer) { create(:user) }
  let(:api_key) { create(:api_key) }

  describe "generate" do
    it "should generate a key upon creation" do 
      key = bearer.api_keys.create!()
      expect(key).to be_persisted
      expect(key.bearer).to eq(bearer)
      expect(key.raw_token).to be_present
    end

    it "should not provide raw token upon update" do
      key = ApiKey.find(api_key.id)
      key.update!(name: "A New Name")
      expect(key.raw_token).to be_nil
    end
  end

  describe "authenticate" do
    it "should authenticate a valid key" do
      expect(ApiKey.authenticate(api_key.raw_token)).to be_truthy
    end

    it "should not authenticate an invalid key" do
      expect(ApiKey.authenticate("invalid")).to be_falsey
    end

    it "should not authenticate an expired key" do
      expired_key = bearer.api_keys.create!(expires_at: 1.month.ago)
      expect(ApiKey.authenticate(expired_key.raw_token)).to be_falsey
    end
  end
end
