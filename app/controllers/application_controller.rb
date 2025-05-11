class ApplicationController < ActionController::API
  before_action :authenticate_user!

  append_view_path "#{Rails.root}/app/views/api/"

  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: exception.message }, status: :forbidden
  end

  private

  def authenticate_user!
    token = request.headers['Authorization'].to_s.split(' ').last
    decoded = JWT.decode(token, Rails.application.secret_key_base)[0]
    user = User.find(decoded['user_id'])

    if user && user.token == token
      @current_user = user
    else
      render json: { error: 'Invalid or expired token' }, status: :unauthorized
    end
  rescue JWT::DecodeError
    render json: { error: 'Invalid token' }, status: :unauthorized
  end

  def current_user
    @current_user
  end
end
