# frozen_string_literal: true

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

    collection do
      get '/summary', action: :summary, as: :summary
    end
  end

  resources :swapp_requests, only: %i[index show create destroy] do
    member do
      patch '/accept_swapp_request', action: :accept_swapp_request,
                                     as: :accept_swapp_request
      patch '/reject_swapp_request', action: :reject_swapp_request,
                                     as: :reject_swapp_request
    end
  end

  resources :auctions, only: %i[index show create update destroy] do
    collection do
      get '/summary', action: :summary, as: :summary
    end
  end

  resources :bids, only: %i[show create] do
    member do
      patch '/accept_bid', action: :accept_bid,
                           as: :accept_bid

    end

    collection do
      get '/summary', action: :summary, as: :summary
    end
  end
end
