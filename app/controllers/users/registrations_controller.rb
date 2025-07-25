# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  before_action :validate_is_signed_in, only: [:upload_avatar, :remove_avatar]

  def upload_avatar
    if current_user.avatar.attach(io: params[:avatar], filename: "avatar")
      redirect_to edit_user_registration_path, notice: "Avatar updated successfully."
    else
      redirect_to edit_user_registration_path, alert: current_user.errors.full_messages.to_sentence + "."
    end
  end

  def remove_avatar
    current_user.avatar.purge
    redirect_to edit_user_registration_path, notice: "Avatar deleted successfully."
  end

  protected

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  private

  def validate_is_signed_in 
    unless current_user
      redirect_to new_user_session_path, alert: "You need to sign in or sign up before continuing."
      return
    end
  end
end
