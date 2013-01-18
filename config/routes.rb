Facelauncher::Application.routes.draw do
  # RailsAdmin
  mount RailsAdmin::Engine => '/admin'
  devise_for :users
  root :to => 'rails_admin/main#dashboard'

  # Resque
  require 'resque/server'
  mount Resque::Server.new, :at => "/resque"

  # Facelauncher API
  resources :programs, :only => [:show]
  resources :program_apps, :only => [:show]
  resources :photo_albums, :only => [:index, :show]
  resources :photos, :only => [:index, :show, :create]
  resources :photo_tags, :only => [:index, :show]
  resources :video_playlists, :only => [:index, :show]
  resources :videos, :only => [:index, :show]
  resources :video_tags, :only => [:index, :show]

#  # API Taster
#  if Rails.env.development?
#    mount ApiTaster::Engine => '/api_taster'
#    ApiTaster.routes do
#      desc 'Get a __program__'
#      get '/programs/:id', {
#        :id => 1,
#        :format => :json
#      }
#
#      desc 'Post a __signup__'
#      post '/signups', {
#        :format => :json,
#        :signup => {
#        :program_id => 1,
#        :program_access_key => '0625e21b0495c2eee75effbdf2016dc6',
#        :email => 'john_doe@test.com',
#        :first_name => 'John',
#        :last_name => 'Doe',
#        :ip_address => '255.255.255.255' }
#      }
#    end
#  end
end
