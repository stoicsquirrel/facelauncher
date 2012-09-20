class ProgramsController < ApplicationController
  before_filter :authenticate

  # GET /programs
  # GET /programs.json
  def index
    @programs = Program.all

    respond_to do |format|
      format.json { render json: @programs }
    end
  end

  # GET /programs/1
  # GET /programs/1.json
  def show
    @program = Program.find(params[:id])

    respond_to do |format|
      format.json do
        if !@program.active?
          render json: { active: false, program_id: params[:id] }
        else
          render json: @program, only: [
            :active, :app_url, :facebook_app_id, :facebook_app_secret, :facebook_is_like_gated,
            :google_analytics_tracking_code, :name, :set_active_date, :set_inactive_date, :short_name],
            methods: [:photo_tags]
        end
      end
    end
  end
end
