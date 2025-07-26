require 'rails_helper'

RSpec.describe "Users", type: :request do
  include MockFile
  let(:user) { create(:user) }
  let(:valid_avatar) { fixture_file_upload("spec/fixtures/valid_avatar.png", "image/png") }
  let(:incorrect_filetype) { fixture_file_upload("spec/fixtures/incorrect_filetype.txt", "text/plain") }
  let(:correct_size_avatar) { Rack::Test::UploadedFile.new(mock_jpg(4.9.megabytes), 'image/jpg', original_filename: 'avatar.jpg') }
  let(:oversized_avatar) { Rack::Test::UploadedFile.new(mock_jpg(5.1.megabytes), 'image/jpg', original_filename: 'avatar.jpg') } 
    
  describe "PATCH #update" do
    context "when logged in" do
      before do
        login_as(user)
      end
      context "with a valid avatar" do
        before do
          patch upload_user_avatar_path, params: { avatar: valid_avatar }
        end

        it { expect(response).to have_http_status(:found) }

        it "should redirect to the edit page" do
          expect(response).to redirect_to(edit_user_registration_path)
        end

        it "should set the correct flash message" do
          expect(flash[:notice]).to eq('Avatar updated successfully.')
        end

        it "should attach" do
          expect(user.reload.avatar.attached?).to be true
        end
      end

      context "with a 4.9 MB avatar" do
        before do 
          patch upload_user_avatar_path, params: { avatar: correct_size_avatar }
        end

        it { expect(response).to have_http_status(:found) }

        it "should redirect to the edit page" do
          expect(response).to redirect_to(edit_user_registration_path)
        end

        it "should set the correct flash message" do
          expect(flash[:notice]).to eq('Avatar updated successfully.')
        end

        it "should attach" do
          expect(user.reload.avatar.attached?).to be true
        end
      end

      context "with a 5.1 MB avatar" do
        before do 
          patch upload_user_avatar_path, params: { avatar: oversized_avatar }
        end

        it { expect(response).to have_http_status(:found) }

        it "should redirect to the edit page" do
          expect(response).to redirect_to(edit_user_registration_path)
        end

        it "should set the correct flash message" do
          expect(flash[:alert]).to eq('Avatar size must be less than 5MB.')
        end

        it "should not attach" do
          expect(user.reload.avatar.attached?).to be false
        end
      end

      context "with an avatar of invalid format" do
        before do
          patch upload_user_avatar_path, params: { avatar: incorrect_filetype }
        end

        it { expect(response).to have_http_status(:found) }

        it "should redirect to the edit page" do
          expect(response).to redirect_to(edit_user_registration_path)
        end

        it "should set the correct flash message" do
          expect(flash[:alert]).to eq('Avatar must be an image.')
        end

        it "should not attach" do
          expect(user.reload.avatar.attached?).to be false
        end
      end
    end

    context "when not logged in" do
      before do 
        patch upload_user_avatar_path, params: { avatar: valid_avatar }
      end

      it { expect(response).to have_http_status(:redirect) }

      it "should redirect to the login page" do
        expect(response).to redirect_to(new_user_session_path)
      end

      it "should not attach" do
        expect(user.reload.avatar.attached?).to be false
      end
    end
  end

  describe "DELETE #destroy" do
    context "when logged in" do
      before { login_as(user) }
      before do
        user.avatar.attach(valid_avatar)
        delete remove_user_avatar_path
      end

      it { expect(response).to have_http_status(:found) }

      it "should redirect to the edit page" do
        expect(response).to redirect_to(edit_user_registration_path)
      end

      it "should set the correct flash message" do
        expect(flash[:notice]).to eq('Avatar deleted successfully.')
      end

      it "should remove the avatar" do
        expect(user.reload.avatar.attached?).to be false
      end
    end

    context "when not logged in" do
      before do
        user.avatar.attach(valid_avatar)
        delete remove_user_avatar_path
      end

      it { expect(response).to have_http_status(:redirect) }

      it "should redirect to the login page" do
        expect(response).to redirect_to(new_user_session_path)
      end

      it "should not remove the avatar" do
        expect(user.reload.avatar.attached?).to be true
      end
    end
  end
end
