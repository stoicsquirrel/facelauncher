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
end
