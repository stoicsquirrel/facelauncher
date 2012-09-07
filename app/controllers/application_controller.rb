class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate

  def authenticate
    authenticate_with_http_basic do |u, p|
      @program = Program.find(u.to_i)
      head :forbidden unless @program.authenticate(p)
    end
  end
end
