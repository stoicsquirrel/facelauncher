class PhotosController < ApplicationController
  # GET /photos.json
  def index
    # Pull photos in the currently logged in program that are approved.
    @photos = Photo.where(program_id: params[:program_id]).approved.order("position ASC")

    respond_to do |format|
      format.json do
        render json: @photos, only: [
          :id, :file, :title, :caption, :from_user_username, :from_user_full_name,
          :from_user_id, :from_service, :position, :photo_album_id, :from_twitter_image_service
        ]
        # TODO: ADD ALBUM INFO HERE!
      end
    end
  end

  # GET /programs/1.json
  def show
    # Pull the selected photo in the currently logged in program if approved.
    @photo = Photo.where(program_id: params[:program_id], id: params[:id]).approved

    respond_to do |format|
      format.json do
        render json: @photos, only: [
          :id, :file, :title, :caption, :from_user_username, :from_user_full_name,
          :from_user_id, :from_service, :position, :photo_album_id, :from_twitter_image_service
        ]
      end
    end
  end
end