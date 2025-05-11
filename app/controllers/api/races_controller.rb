class Api::RacesController < ApplicationController
  load_and_authorize_resource :track, only: [:index, :create]
  load_and_authorize_resource :race, through: :track, only: [:index, :create]
  load_and_authorize_resource except: [:index, :create]

  def index
    races = @track.races

    @search = races.ransack(params[:q])
    @races = @search.result(distinct: true).page(params[:page])

    if @races
      render 'races/index'
    else
      render json: @races.errors, status: :bad_request
    end
  end

  def show
    render json: @race
  end

  def create
    @race = @track.races.build(race_params)
    if @race.save
      render json: @race, status: :created
    else
      render json: @race.errors, status: :unprocessable_entity
    end
  end

  def update
    if @race.update(race_params)
      render json: @race
    else
      render json: @race.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @race.destroy
    head :no_content
  end

  private

  def race_params
    params.require(:race).permit(:name, :start_time, :end_time, :track_id)
  end
end