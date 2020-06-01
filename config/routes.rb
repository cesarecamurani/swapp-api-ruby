Rails.application.routes.draw do
  post '/login', to: 'authentication#login'
  post '/logout', to: 'authentication#logout'
end
