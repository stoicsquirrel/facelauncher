class ProgramAppsController < ApplicationController
  before_filter :authenticate

  # GET /program_apps/1
  # GET /program_apps/1.json
  def show
    @program_app = ProgramApp.find(params[:id])

    respond_to do |format|
      format.json do
        render json: @program_app
      end
    end
  end
end