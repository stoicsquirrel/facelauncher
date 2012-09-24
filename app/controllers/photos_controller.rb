class PhotosController < ApplicationController
  before_filter :authenticate, :only => :create

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
    @photo = Photo.approved.find(params[:id])

    respond_to do |format|
      format.html do
        @program = @photo.program
        deep_link = true
        if deep_link && !@program.app_url.blank?
          redirect_to "#{@program.app_url}#photo=#{@photo.id}"
        else
          redirect_to @photo.file.url
        end
      end
      format.json do
        render json: @photo, only: [
          :id, :file, :title, :caption, :from_user_username, :from_user_full_name,
          :from_user_id, :from_service, :position, :photo_album_id, :from_twitter_image_service
        ]
      end
    end
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo = Photo.new(params[:photo])

    respond_to do |format|
      if @photo.save
        format.json do
          binding.pry
          render json: { :id => @photo.id, :filename => File.basename(@photo.file.url) }
        end
      else
        format.json do
          head :bad_request
        end
      end
    end
  end
end