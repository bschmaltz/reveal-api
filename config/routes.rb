Rails.application.routes.draw do
  root to: 'user#index'

  post '/users/login', to: 'users#login', defaults: { format: :json }
  resources :users, defaults: { format: :json }
end
