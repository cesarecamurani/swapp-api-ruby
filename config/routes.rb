Rails.application.routes.draw do
  post '/auth/login', to: 'authentication#login'
  post '/auth/logout', to: 'authentication#logout'

  resources :users, only: %i[show create update destroy]
  
  resources :swappers, only: %i[index show create update destroy] do
    member do
      put '/upload_avatar', action: :upload_avatar, as: :upload_avatar
      get '/remove_avatar', action: :remove_avatar, as: :remove_avatar
    end  
  end

  resources :products, only: %i[index show create update destroy] do
    member do
      put '/upload_images', action: :upload_images, as: :upload_images
      get '/remove_image/:image_id', action: :remove_image, as: :remove_image
    end
  end
end
