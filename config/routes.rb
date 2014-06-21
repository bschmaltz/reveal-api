Rails.application.routes.draw do
  match '*path', to: 'application#cors_preflight_check', via: [:options]
  root to: 'user#index'

  post '/users/login', to: 'users#login', defaults: { format: :json }
  resources :users, defaults: { format: :json }

  post '/posts', to: 'posts#create', defaults: {format: :json}
  get '/posts/index', to: 'posts#index', defaults: { format: :json }
  get '/posts/index/:last_post_id', to: 'posts#index', defaults: { format: :json }
  get '/posts/index_for_user/:user_id', to: 'posts#index_for_user', defaults: { format: :json }
  get '/posts/index_followed_posts', to: 'posts#index_followed_posts', defaults: { format: :json }
  get '/posts/index_followed_posts/:last_post_id', to: 'posts#index_followed_posts', defaults: { format: :json }
  get '/posts/show/:id', to: 'posts#show', defaults: { format: :json }
  put '/posts/:id', to: 'posts#update', defaults: {format: :json}
  delete '/posts/:id', to: 'posts#destroy', defaults: {format: :json}
  put '/posts/reveal/:id', to: 'posts#reveal', defaults: { format: :json }
  put '/posts/hide/:id', to: 'posts#hide', defaults: { format: :json }

  post '/votes', to: 'votes#create', defaults: { format: :json }
  put '/votes/update', to: 'votes#update', defaults: { format: :json }
  delete '/votes/destroy/:user_id/:post_id', to: 'votes#destroy', defaults: { format: :json }

  post '/shares', to: 'shares#create', defaults: { format: :json }
  delete '/shares/:user_id/:post_id', to: 'shares#destroy', defaults: { format: :json }

  post '/followers', to: 'followers#create', defaults: { format: :json }
  get '/followers/:user_id', to: 'followers#get_followers_for_user', defaults: { format: :json }
  get '/followed/:user_id', to: 'followers#get_followed_for_user', defaults: { format: :json }
  delete '/followers/:id', to: 'followers#destroy', defaults: { format: :json }
end
