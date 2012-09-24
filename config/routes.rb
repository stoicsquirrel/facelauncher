Facelauncher::Application.routes.draw do
  devise_for :users

  root :to => 'rails_admin/main#dashboard'

  # RailsAdmin
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  # Resque
  require 'resque/server'
  require 'resque_scheduler/server'
  mount Resque::Server.new, :at => "/resque"

  # Facelauncher API
  resources :programs, :only => [:index, :show]
  resources :photo_albums, :only => [:index, :show]
  resources :photos, :only => [:index, :show, :create]
  resources :video_playlists, :only => [:index, :show]
  resources :videos, :only => [:index, :show]
  resources :signups, :only => [:create]

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

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
