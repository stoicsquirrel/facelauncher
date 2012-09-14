class VideoPlaylistsController < ApplicationController
  # GET /video_playlists
  # GET /video_playlists.json
  def index
    # Pull video playlists in the selected program, if a program_id is given.
    if !params[:name].nil?
      @video_playlists = VideoPlaylist.find_by_name(params[:name])
    elsif !params[:program_id].nil?
      @video_playlists = VideoPlaylist.where(program_id: params[:program_id])
    end

    respond_to do |format|
      format.json do
        if include_videos?
          render json: @video_playlists, only: [:id, :program_id, :name, :screenshot],
            methods: [:approved_videos]
        else
          render json: @video_playlists, only: [:id, :program_id, :name, :screenshot]
        end
      end
    end
  end

  # GET /video_playlists/1
  # GET /video_playlists/1.json
  def show
    # Pull the selected video playlist.
    @video_playlist = Video.find(params[:id])

    respond_to do |format|
      format.json do
        if include_videos?
          render json: @video_playlist, only: [:id, :program_id, :name, :screenshot],
            methods: [:approved_videos]
        else
          render json: @video_playlist, only: [:id, :program_id, :name, :screenshot]
        end
      end
    end
  end

  private
  def include_videos?
    !params[:include_videos].nil? && (params[:include_videos] == '1' || params[:include_videos] == 'true')
  end
end