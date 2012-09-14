class VideosController < ApplicationController
  # GET /videos
  # GET /videos.json
  def index
    # Pull videos in the selected program or videos playlist that are approved.
    if !params[:video_playlist_id].nil?
      @videos = Video.where(video_playlist_id: params[:video_playlist_id]).approved.order("position ASC")
    elsif !params[:program_id].nil?
      @videos = Video.where(program_id: params[:program_id]).approved.order("position ASC")
    end

    respond_to do |format|
      format.json do
        render json: @videos, only: [:id, :embed_code, :caption, :position, :screenshot]
      end
    end
  end

  # GET /video/1
  # GET /video/1.json
  def show
    # Pull the selected video, if approved.
    @video = Video.find(params[:id]).approved

    respond_to do |format|
      format.json do
        render json: @video, only: [:id, :embed_code, :caption, :position, :screenshot]
      end
    end
  end
end