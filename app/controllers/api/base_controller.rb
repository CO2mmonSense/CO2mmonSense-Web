class Api::BaseController < ActionController::API 
    def authenticate_api_key!
        token = request.headers['Authorization']&.split&.last
        return render json: { error: 'Not Authorized' }, status: :unauthorized unless ApiKey.authenticate(token)
    end
end