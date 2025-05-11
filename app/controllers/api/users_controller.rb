class Api::UsersController < ApplicationController
  def index
    users = User.all

    @search = users.ransack(params[:q])
    @users = @search.result(distinct: true).page(params[:page])

    if @users
      render json: @users
    else
      render json: @users.errors, status: :bad_request
    end
  end
end
