class Api::SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:login]

  def login
    user = User.find_by(email: login_params[:email])

    if user&.valid_password?(login_params[:password])
      user.set_token
      render json: { status: "Login successfull", token: user.token, role_mask: user.role_mask, id: user.id }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def logout
    user = User.find_by(token: request.headers['Authorization'].split(' ').last)

    if user
      user.update(token: nil)
      render json: { status: 'Logout successfull' }, status: :ok
    else
      render json: { error: 'Token invalid or expired' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
