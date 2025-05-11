class Api::LapsController < ApplicationController
  load_and_authorize_resource :race, only: [:index, :create]
  load_and_authorize_resource :lap, through: :race, only: [:index, :create]
  load_and_authorize_resource except: [:index, :create]

  def index
    laps = @race.laps
    @track = @race.track

    @search = laps.ransack(params[:q])
    @laps = @search.result(distinct: true).page(params[:page])

    if @laps
      render 'laps/index'
    else
      render json: @laps.errors, status: :bad_request
    end
  end

  def show
    render json: @lap
  end

  def create
    @lap = @race.laps.build(lap_params)
    if @lap.save
      render json: @lap, status: :created
    else
      render json: @lap.errors, status: :unprocessable_entity
    end
  end

  def update
    if @lap.update(lap_params)
      render json: @lap
    else
      render json: @lap.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @lap.destroy
    head :no_content
  end

  private

  def set_race
    @race = Race.find(params[:race_id])
  end

  def set_lap
    @lap = Lap.find(params[:id])
  end

  def lap_params
    params.require(:lap).permit(:user_id, :race_id, :lap_number, :lap_time_seconds, :position)
  end
end
