class PhotoTagsController < ApplicationController
  # GET /photo_tags
  # GET /photo_tags.json
  def index
    # Pull photo tags for the selected photo, if a photo_id is given.
    unless params[:photo_id].nil?
      @photo_tags = PhotoTag.where(photo_id: params[:photo_id])
    end

    respond_to do |format|
      format.json do
        render json: @photo_tags
      end
    end
  end

  # GET /photo_tags/1
  # GET /photo_tags/1.json
  def show
    # Pull the selected photo album.
    @photo_tag = PhotoTag.find(params[:id])

    respond_to do |format|
      format.json do
        render json: @photo_tag
      end
    end
  end
end