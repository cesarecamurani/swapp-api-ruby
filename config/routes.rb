Rails.application.routes.draw do
  post '/auth/login', to: 'authentication#login'
  post '/auth/logout', to: 'authentication#logout'

  resources :users, only: %i[show create update]
end
