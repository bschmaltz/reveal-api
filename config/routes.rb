Rails.application.routes.draw do
  root to: 'user#index'

  post '/users/login', to: 'users#login', defaults: { format: :json }
  resources :users, defaults: { format: :json }

  put '/posts/reveal/:id', to: 'posts#reveal', defaults: { format: :json }
  put '/posts/hide/:id', to: 'posts#hide', defaults: { format: :json }
  resources :posts, defaults: { format: :json }

  post '/votes', to: 'votes#create', defaults: { format: :json }
  put '/votes/update', to: 'votes#update', defaults: { format: :json }
  delete '/votes/destroy/:user_id/:post_id', to: 'votes#destroy', defaults: { format: :json }
end
