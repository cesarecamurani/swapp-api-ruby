Rails.application.routes.draw do
  post '/auth/login', to: 'authentication#login'
  post '/auth/logout', to: 'authentication#logout'

  resources :users, only: %i[show create update destroy]
  
  resources :swappers, only: %i[index show create update destroy] do
    member do
      post '/upload_avatar', action: :upload_avatar, as: :upload_avatar
    end  
  end

  resources :products, only: %i[index show create update destroy] do
    member do
      post '/upload_images', action: :upload_images, as: :upload_images
    end
  end
end
