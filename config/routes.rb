Rails.application.routes.draw do
  root to: 'user#index'

  resources :users, defaults: { format: :json }
  resources :sessions, defaults: { format: :json }
end
