class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate
    authenticate_with_http_basic do |u, p|
      @program = Program.find(u.to_i)
      # Exit the method and continue if authenticated.
      return if @program.authenticate(p)
    end
    # Send a simple 403 header response if not authenticated.
    head :forbidden
  end

  # Allow JSON requests to bypass CSRF verification.
  def verified_request?
    if (!request.format.nil? && request.format.json?) || request.content_type == "application/json"
      true
    else
      super
    end
  end
end
