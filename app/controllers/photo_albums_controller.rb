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

    #respond_to do |format|
    #  format.json do
        if include_photos?
          output = []
          @photo_albums.each do |photo_album|
            approved_photos = []
            photo_album.photos.approved.each do |photo|
              approved_photos << { id: photo.id,
                                   file: photo.file,
                                   caption: photo.caption,
                                   from_user_username: photo.from_user_username,
                                   from_user_full_name: photo.from_user_full_name,
                                   from_user_id: photo.from_user_id,
                                   from_service: photo.from_service,
                                   position: photo.position,
                                   from_twitter_image_service: photo.from_twitter_image_service,
                                   tags: photo.photo_tags.select([:id, :tag]) }
            end
            output << { id: photo_album.id,
                        program_id: photo_album.program_id,
                        name: photo_album.name,
                        approved_photos: approved_photos
                      }
          end
          render json: output
        else
          render json: @photo_albums, only: [:id, :program_id, :name]
        end
    #  end
    #end
  end

  # GET /photo_albums/1
  # GET /photo_albums/1.json
  def show
    # Pull the selected photo album.
    @photo_album = PhotoAlbum.find(params[:id])

    #respond_to do |format|
    #  format.json do
        if include_photos?
          approved_photos = []
          @photo_album.photos.approved.each do |photo|
            approved_photos << { id: photo.id,
                                 file: photo.file,
                                 caption: photo.caption,
                                 from_user_username: photo.from_user_username,
                                 from_user_full_name: photo.from_user_full_name,
                                 from_user_id: photo.from_user_id,
                                 from_service: photo.from_service,
                                 position: photo.position,
                                 from_twitter_image_service: photo.from_twitter_image_service,
                                 tags: photo.photo_tags.select([:id, :tag]) }
          end
          render json: { id: @photo_album.id,
                         program_id: @photo_album.program_id,
                         name: @photo_album.name,
                         approved_photos: approved_photos
                       }
        else
          render json: @photo_album, only: [:id, :program_id, :name]
        end
    #  end
    #end
  end

  private
  def include_photos?
    !params[:include_photos].nil? && (params[:include_photos] == '1' || params[:include_photos] == 'true')
  end
end