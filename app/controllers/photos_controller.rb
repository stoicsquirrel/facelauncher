class PhotosController < ApplicationController
  # GET /photos
  # GET /photos.json
  def index
    # Pull photos in the selected program or photo album that are approved.
    if !params[:photo_album_id].nil?
      @photos = Photo.where(photo_album_id: params[:photo_album_id]).approved.order("position ASC")
    elsif !params[:program_id].nil?
      @photos = Photo.where(program_id: params[:program_id]).approved.order("position ASC")
#    else
#      @photos = Photo.approved.order("position ASC")
    end

    respond_to do |format|
      format.json do
        render json: @photos, only: [
          :id, :file, :caption, :from_user_username, :from_user_full_name,
          :from_user_id, :from_service, :position, :photo_album_id, :from_twitter_image_service
        ]
      end
    end
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    # Pull the selected photo, if approved.
    @photo = Photo.find(params[:id]).approved

    respond_to do |format|
      format.json do
        render json: @photo, only: [
          :id, :file, :title, :caption, :from_user_username, :from_user_full_name,
          :from_user_id, :from_service, :position, :photo_album_id, :from_twitter_image_service
        ]
      end
    end
  end
end