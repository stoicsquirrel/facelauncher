class VideosController < ApplicationController
  # GET /videos
  # GET /videos.json
  def index
    # Pull videos in the selected program or videos playlist that are approved.
    if !params[:video_playlist_id].nil?
      @videos = Video.where(video_playlist_id: params[:video_playlist_id]).approved.order("position ASC")
    elsif !params[:program_id].nil?
      @videos = Video.where(program_id: params[:program_id]).approved.order("position ASC")
    end

    respond_to do |format|
      format.json do
        # TODO: Add check to determine if there are any videos. If not return an error.
        videos = []
        unless @videos.nil?
          @videos.each do |video|
            videos << {
              id: video.id,
              video_playlist_id: video.video_playlist_id,
              embed_code: video.embed_code,
              embed_id: video.embed_id,
              title: video.title,
              subtitle: video.subtitle,
              caption: video.caption,
              position: video.position,
              screenshot: !video.screenshot.nil? ? {
                url: video.screenshot.url,
                filename: File.basename(video.screenshot.url)
              } : nil,
              tags: video.video_tags.select([:id, :tag]),
              created_at: video.created_at,
              updated_at: video.updated_at
            }
          end
        end

        render json: videos
      end
    end
  end

  # GET /video/1
  # GET /video/1.json
  def show
    # Pull the selected video, if approved.
    @video = Video.approved.find(params[:id])

    respond_to do |format|
      format.json do
        render json: {
          id: @video.id,
          video_playlist_id: @video.video_playlist_id,
          embed_code: @video.embed_code,
          embed_id: @video.embed_id,
          title: @video.title,
          subtitle: @video.subtitle,
          caption: @video.caption,
          position: @video.position,
          screenshot: {
            url: @video.screenshot.url,
            filename: File.basename(@video.screenshot.url)
          },
          tags: @video.video_tags.select([:id, :tag]),
          created_at: @video.created_at,
          updated_at: @video.updated_at
        }
      end
    end
  end
end