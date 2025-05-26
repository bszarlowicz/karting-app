class Api::RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  def create
    user = User.new(user_params)
    if user.save
      user.set_token
      render json: { token: user.token, role_mask: user.role_mask, id: user.id }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :birthdate, :password, :password_confirmation)
  end

end
