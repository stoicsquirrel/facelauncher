class VideoTagsController < ApplicationController
  # GET /video_tags
  # GET /video_tags.json
  def index
    # Pull video tags for the selected video, if a video_id is given.
    unless params[:video_id].nil?
      @video_tags = VideoTag.where(video_id: params[:video_id])
    end

    respond_to do |format|
      format.json do
        render json: @video_tags
      end
    end
  end

  # GET /video_tags/1
  # GET /video_tags/1.json
  def show
    # Pull the selected video album.
    @video_tag = VideoTag.find(params[:id])

    respond_to do |format|
      format.json do
        render json: @video_tag
      end
    end
  end
end