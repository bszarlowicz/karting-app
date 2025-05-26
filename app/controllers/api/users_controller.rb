class Api::UsersController < ApplicationController
  def index
    users = User.all

    @search = users.ransack(params[:q])
    @users = @search.result(distinct: true).page(params[:page])

    if @users
      render 'users/index'
    else
      render json: @users.errors, status: :bad_request
    end
  end

  def show
    @user = User.find_by(id: params[:id])

    if @user
      render json: @user, status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  def laps
    @user = User.find_by(id: params[:id])

    if @user
      laps_data = @user.laps.includes(race: :track).map do |lap|
        {
          id: lap.id,
          lap_time_seconds: lap.lap_time_seconds,
          lap_number: lap.lap_number,
          position: lap.position,
          race_id: lap.race_id,
          created_at: lap.created_at,
          updated_at: lap.updated_at,
          track_name: lap.race&.track&.name,
          username: lap.user.first_name
        }
      end

      render json: laps_data, status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end


  private

  def set_user
    @user = User.find_by(id: params[:id])
    render json: { error: 'User not found' }, status: :not_found unless @user
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :birthdate, :role_mask, :password, :password_confirmation)
  end
end
