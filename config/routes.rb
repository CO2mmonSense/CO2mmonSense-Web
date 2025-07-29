Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  devise_scope :user do
    patch 'users/avatar', to: 'users/registrations#upload_avatar', as: :upload_user_avatar
    delete 'users/avatar', to: 'users/registrations#remove_avatar', as: :remove_user_avatar
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"

  resources :sensors

  namespace :api do
    get 'documentation', to: 'documentation#index'
    resources :keys, except: :show
  end

  constraints subdomain: "api" do
    scope module: "api", as: "api" do
      namespace :v1 do
        post 'sensors/:sender_id/readings', to: 'readings#create', as: :create_readings
        resources :sensors, only: [:show, :index] do
          get 'readings', to: 'readings#index'
        end
      end
    end
  end
end
