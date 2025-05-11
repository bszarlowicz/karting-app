class Api::TracksController < ApplicationController
  load_and_authorize_resource

  def index
    tracks = Track.all

    @search = tracks.ransack(params[:q])
    @tracks = @search.result(distinct: true).page(params[:page])

    if @tracks
      render json: @tracks
    else
      render json: @tracks.errors, status: :bad_request
    end
    
  end

  def show
    @track = Track.find_by(id: params[:id])

    if @track
      render json: @track, status: :ok
    else
      render json: { error: 'Track not found' }, status: :not_found
    end
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
    @track = Track.find_by(id: params[:id])
  
    if @track
      @track.destroy
      head :no_content
    else
      render json: { error: "Nie znaleziono toru" }, status: :not_found
    end
  end    

  private

  def track_params
    params.require(:track).permit(:name, :location, :length_meters, :is_indoor)
  end
end
