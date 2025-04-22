Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    post 'login', to: 'sessions#login'
    delete 'logout', to: 'sessions#logout'

    resources :registrations, only: [:create]

    resources :users, only: [:index]
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
