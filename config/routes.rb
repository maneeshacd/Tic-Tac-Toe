Rails.application.routes.draw do
  root 'dashboard#index'
  namespace :api do
    resources :games
    resources :game_players do
      member do
        post :movement
      end
    end
  end
end
