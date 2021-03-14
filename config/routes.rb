Rails.application.routes.draw do
  
  get 'notifications/index'
  get 'stats' => 'stats#index'
  root to: 'home#index'

  devise_for :user
  get '/tagged', to: "home#tagged", as: :tagged
  get 'feed' => 'home#feed'

  resources :articles do
    resource :favorite, only: %i[create destroy]
    resources :comments
  end
  resources :notifications, only: [:index]
  resources :tags, only: [:index]

  resources :profiles, only: [:show] do
    member do
      get :following, :followers
    end
    resource :follow, only: [:create, :destroy]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
