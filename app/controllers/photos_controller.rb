class PhotosController < ApplicationController
  before_filter :authenticate, :only => :create

  # GET /photos
  # GET /photos.json
  def index
    # Pull photos in the selected program or photo album that are approved.
    if !params[:next_id].nil?
      #query = ActiveRecord::Base.connection.raw_connection.prepare("SELECT row_num FROM (SELECT ROW_NUMBER() OVER(ORDER BY position ASC, updated_at DESC) AS row_num, id FROM :table) AS sub WHERE sub.id = :next_id")
      #offset = query.execute(:table => self.class.table_name, :next_id => params[:next_id])
      #query.close
    end

    offset = params[:offset]
    if !params[:photo_album_id].nil?
      @photos = Photo.where(photo_album_id: params[:photo_album_id]).approved.order("position ASC, updated_at DESC").limit(params[:limit]).offset(offset)
    elsif !params[:program_id].nil?
      @photos = Photo.where(program_id: params[:program_id]).approved.order("position ASC, updated_at DESC").limit(params[:limit]).offset(offset)
    end

    respond_to do |format|
      format.json do
        # TODO: Add check to determine if there are any photos. If not return an error.
        photos = []
        unless @photos.nil?
          @photos.each do |photo|
            photos << {
              id: photo.id,
              photo_album_id: photo.photo_album_id,
              file: {
                url: photo.file.url,
                filename: File.basename(photo.file.url)
              },
              caption: photo.caption,
              from_user_username: photo.from_user_username,
              from_user_full_name: photo.from_user_full_name,
              from_user_id: photo.from_user_id,
              from_service: photo.from_service,
              position: photo.position,
              from_twitter_image_service: photo.from_twitter_image_service,
              tags: photo.photo_tags.select([:id, :tag]),
              created_at: photo.created_at,
              updated_at: photo.updated_at
            }
          end
        end

        render json: photos
      end
    end
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    # Pull the selected photo, if approved.
    @photo = Photo.approved.find(params[:id])

    respond_to do |format|
      format.json do
        render json: {
          id: @photo.id,
          photo_album_id: @photo.photo_album_id,
          file: {
            url: @photo.file.url,
            filename: File.basename(@photo.file.url)
          },
          caption: @photo.caption,
          from_user_username: @photo.from_user_username,
          from_user_full_name: @photo.from_user_full_name,
          from_user_id: @photo.from_user_id,
          from_service: @photo.from_service,
          position: @photo.position,
          from_twitter_image_service: @photo.from_twitter_image_service,
          tags: @photo.photo_tags.select([:id, :tag]),
          created_at: @photo.created_at,
          updated_at: @photo.updated_at
        }
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