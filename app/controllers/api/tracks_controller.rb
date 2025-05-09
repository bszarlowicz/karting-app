class Api::TracksController < ApplicationController
  before_action :set_track, only: [:show, :update, :destroy]

  def index
    tracks = Track.all

    @search = tracks.ransack(params[:q])
    @tracks = @search.result(distinct: true).page(params[:page])

    if @tracks
      render 'tracks/index'
    else
      render json: @tracks.errors, status: :bad_request
    end
    
  end

  def show
    render json: @track, status: :ok
  end

  def create
    @track = Track.new(track_params)

    if @track.save
      render json: @track, status: :created
    else
      render json: { errors: @track.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @track.update(track_params)
      render json: @track, status: :ok
    else
      render json: { errors: @track.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @track.destroy
    head :no_content
  end

  private

  def set_track
    @track = Track.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Track not found" }, status: :not_found
  end

  def track_params
    params.require(:track).permit(:name, :location, :length_meters, :is_indoor)
  end
end
