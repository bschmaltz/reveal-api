Rails.application.routes.draw do
  root to: 'user#index'

  post '/users/login', to: 'users#login', defaults: { format: :json }
  resources :users, defaults: { format: :json }

  post '/posts', to: 'posts#create', defaults: {format: :json}
  get '/posts/index', to: 'posts#index', defaults: { format: :json }
  get '/posts/index/:last_post_id', to: 'posts#index', defaults: { format: :json }
  get '/posts/show/:id', to: 'posts#show', defaults: { format: :json }
  put '/posts/:id', to: 'posts#update', defaults: {format: :json}
  delete '/posts/:id', to: 'posts#destroy', defaults: {format: :json}
  put '/posts/reveal/:id', to: 'posts#reveal', defaults: { format: :json }
  put '/posts/hide/:id', to: 'posts#hide', defaults: { format: :json }

  post '/votes', to: 'votes#create', defaults: { format: :json }
  put '/votes/update', to: 'votes#update', defaults: { format: :json }
  delete '/votes/destroy/:user_id/:post_id', to: 'votes#destroy', defaults: { format: :json }

  post '/followers', to: 'followers#create', defaults: { format: :json }
  get '/followers/:user_id', to: 'followers#get_followers_for_user', defaults: { format: :json }
  get '/followed/:user_id', to: 'followers#get_followed_for_user', defaults: { format: :json }
  delete '/followers/:id', to: 'followers#destroy', defaults: { format: :json }
end
