Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Active Storage routes (required for serving images)
  # These are automatically included by Rails but we ensure they're present

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service-worker", as: :pwa_service_worker

  # Authentication routes
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # User management
  resource :user, only: [ :edit, :update ] do
    member do
      patch :update_password
    end
  end

  # Defines the root path route ("/")
  root "items#index"

  resources :items do
    member do
      patch :increment
      patch :decrement
    end

    collection do
      get :restocking
    end
  end
end
