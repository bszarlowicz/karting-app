Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  #devise_for :users

  namespace :api do
    post 'login', to: 'sessions#login'
    delete 'logout', to: 'sessions#logout'

    resources :registrations, only: [:create]

    resources :users do
      member do
        get :laps
      end
    end

    resources :tracks do
      resources :races, shallow: true do
        resources :laps, shallow: true
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
