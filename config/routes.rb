Rails.application.routes.draw do
  root to: 'user#index'

  post '/users/login', to: 'users#login', defaults: { format: :json }
  resources :users, defaults: { format: :json }

  put '/posts/reveal/:id', to: 'posts#reveal', defaults: { format: :json }
  put '/posts/hide/:id', to: 'posts#hide', defaults: { format: :json }
  resources :posts, defaults: { format: :json }
end
