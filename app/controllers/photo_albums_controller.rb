class PhotoAlbumsController < ApplicationController
  # GET /photo_albums
  # GET /photo_albums.json
  def index
    # Pull photo albums in the selected program, if a program_id is given.
    if !params[:name].nil?
      @photo_albums = PhotoAlbum.find_by_name(params[:name])
    elsif !params[:program_id].nil?
      @photo_albums = PhotoAlbum.where(program_id: params[:program_id])
#    else
#      @photo_albums = PhotoAlbum.all
    end

    respond_to do |format|
      format.json do
        if include_photos?
          render json: @photo_albums, only: [:id, :program_id, :name],
            methods: [:approved_photos]
        else
          render json: @photo_albums, only: [:id, :program_id, :name]
        end
      end
    end
  end

  # GET /photo_albums/1
  # GET /photo_albums/1.json
  def show
    # Pull the selected photo album.
    @photo_album = Photo.find(params[:id])

    respond_to do |format|
      format.json do
        if include_photos?
          render json: @photo_album, only: [:id, :program_id, :name],
            methods: [:approved_photos]
        else
          render json: @photo_album, only: [:id, :program_id, :name]
        end
      end
    end
  end

  private
  def include_photos?
    !params[:include_photos].nil? && (params[:include_photos] == '1' || params[:include_photos] == 'true')
  end
end