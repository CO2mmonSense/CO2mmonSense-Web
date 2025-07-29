class Api::KeysController < ApplicationController
    before_action :set_api_key, except: [:index, :new, :create]
    before_action :authenticate_user!
    before_action :authorize_user!, except: [:index, :new, :create]

    def index
        @api_keys = current_user.api_keys
    end

    def new
        @api_key = current_user.api_keys.build
    end

    def create
        @api_key = current_user.api_keys.build(api_key_params)
        if @api_key.save
            flash[:raw_api_key] = @api_key.raw_token
            redirect_to api_keys_path, notice: 'API key was successfully created.'
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @api_key.update(api_key_params)
            redirect_to api_keys_path, notice: 'API key was successfully updated.'
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        if @api_key.destroy
            redirect_to api_keys_path, notice: "API key deleted successfully."
        else
            redirect_to api_keys_path, alert: "Unable to delete API key."
        end
    end

    private 

    def api_key_params
        params.require(:api_key).permit(:name, :expires_at)
    end

    def authorize_user!
        unless @api_key.bearer == current_user
            redirect_to api_keys_path, alert: "You are not authorized to perform this action."
        end
    end

    def set_api_key
        @api_key = ApiKey.find(params[:id])
    end
end
