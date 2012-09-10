class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate
    authenticate_with_http_basic do |u, p|
      @program = Program.find(u.to_i)
      # Send a simple 403 header response if not authenticated.
      head :forbidden unless @program.authenticate(p)
    end
  end
end
