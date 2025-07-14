require 'rails_helper'

RSpec.describe User, type: :model do
  include MockFile
  let(:valid_avatar) { fixture_file_upload("spec/fixtures/valid_avatar.png", "image/png") }
  let(:incorrect_filetype) { fixture_file_upload("spec/fixtures/incorrect_filetype.txt", "text/plain") }
  let(:correct_size_avatar) { Rack::Test::UploadedFile.new(mock_jpg(4.9.megabytes), 'image/jpg', original_filename: 'avatar.jpg') }
  let(:oversized_avatar) { Rack::Test::UploadedFile.new(mock_jpg(5.1.megabytes), 'image/jpg', original_filename: 'avatar.jpg') } 
  let(:user) { FactoryBot.create(:user) }

  describe "avatar validations" do
    context 'when avatar is not attached' do
      it { expect(user).to be_valid }
    end

    context 'when avatar is valid' do
      before do
        user.avatar.attach(valid_avatar)
      end

      it { expect(user).to be_valid }
    end

    context 'when avatar has invalid format' do
      before do
        user.avatar.attach(incorrect_filetype)
      end

      it 'adds the correct error message' do
        expect(user.errors[:avatar]).to include('must be an image')
      end

      it 'purges the invalid attachment' do
        expect(user.avatar).to_not be_attached
      end
    end

    context 'when avatar is the correct size' do
      before do
        user.avatar.attach(correct_size_avatar)
      end

      it { expect(user).to be_valid }
    end

    context 'when avatar is too large' do
      before do
        user.avatar.attach(oversized_avatar)
      end

      it 'adds correct error message' do
        expect(user.errors[:avatar]).to include('size must be less than 5MB')
      end

      it 'purges the oversized attachment' do
        expect(user.avatar).to_not be_attached
      end
    end
  end
end