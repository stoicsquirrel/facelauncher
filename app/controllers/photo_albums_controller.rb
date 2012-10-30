class PhotoAlbumsController < ApplicationController
  # GET /photo_albums
  # GET /photo_albums.json
  def index
    # Pull photo albums in the selected program, if a program_id is given.
    if !params[:name].nil?
      @photo_albums = PhotoAlbum.find_by_name(params[:name])
    elsif !params[:program_id].nil?
      @photo_albums = PhotoAlbum.where(program_id: params[:program_id])
    end

    respond_to do |format|
      format.json do
        render json: @photo_albums
      end
    end
  end

  # GET /photo_albums/1
  # GET /photo_albums/1.json
  def show
    # Pull the selected photo album.
    @photo_album = PhotoAlbum.find(params[:id])

    respond_to do |format|
      format.json do
        render json: @photo_album
      end
    end
  end
end