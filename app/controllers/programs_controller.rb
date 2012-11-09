class ProgramsController < ApplicationController
  before_filter :authenticate

  # GET /programs/1
  # GET /programs/1.json
  def show
    respond_to do |format|
      format.json do
        if !@program.active?
          render json: { active: false, program_id: params[:id] }
        else
          render json: @program, only: [
            :id, :active, :app_url, :name, :short_name, :description,
            :additional_info_1, :additional_info_2, :additional_info_3,
            :photos_updated_at, :videos_updated_at, :created_at, :updated_at
          ],
          include: :program_apps,
          methods: :photo_tags
        end
      end
    end
  end
end
