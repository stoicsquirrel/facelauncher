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

    #respond_to do |format|
    #  format.json do
        if include_videos?
          output = []
          @video_playlists.each do |video_playlist|
            approved_videos = []
            video_playlist.videos.approved.order(video_playlist.sort_order).each do |video|
              approved_videos << { id: video.id,
                                   caption: video.caption,
                                   embed_code: video.embed_code,
                                   position: video.position,
                                   screenshot: { url: video.screenshot.url },
                                   tags: video.video_tags.select([:id, :tag]),
                                   created_at: video.created_at,
                                   updated_at: video.updated_at }
            end
            output << { id: video_playlist.id,
                        program_id: video_playlist.program_id,
                        name: video_playlist.name,
                        approved_videos: approved_videos
                      }
          end
          render json: output
        else
          render json: @video_playlists, only: [:id, :program_id, :name, :screenshot]
        end
    #  end
    #end
  end

  # GET /video_playlists/1
  # GET /video_playlists/1.json
  def show
    # Pull the selected video playlist.
    @video_playlist = VideoPlaylist.find(params[:id])

    #respond_to do |format|
    #  format.json do
        if include_videos?
          approved_videos = []
          @video_playlist.videos.approved.order(@video_playlist.sort_order).each do |video|
            approved_videos << { id: video.id,
                                 caption: video.caption,
                                 embed_code: video.embed_code,
                                 position: video.position,
                                 screenshot: { url: video.screenshot.url },
                                 tags: video.video_tags.select([:id, :tag]),
                                 created_at: video.created_at,
                                 updated_at: video.updated_at }
          end
          render json: { id: @video_playlist.id,
                         program_id: @video_playlist.program_id,
                         name: @video_playlist.name,
                         approved_videos: approved_videos
                       }
        else
          render json: @video_playlist, only: [:id, :program_id, :name, :screenshot]
        end
    #  end
    #end
  end

  private
  def include_videos?
    !params[:include_videos].nil? && (params[:include_videos] == '1' || params[:include_videos] == 'true')
  end
end