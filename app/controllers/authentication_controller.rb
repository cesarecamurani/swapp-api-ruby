# frozen_string_literal: true

class AuthenticationController < ApplicationController
  skip_before_action :authorize_request
 
  def login
    user = User.find_by(email: params[:email])
    
    unless user&.authenticate(params[:password])
      raise_unauthorized_with('Invalid credentials')
    end

    unless (auth_token = JsonWebToken.encode(payload: { user_id: user.id }))
      raise_unauthorized_with('Invalid or missing token')
    end

    render json: auth_response(auth_token, user.id), status: :ok
  end

  def logout
    invalidate_token
    message = { message: 'You\'ve been logged out' }
    render json: message, status: :ok
  end

  private

  def invalidate_token
    raise_unauthorized_with('Invalid or missing token') unless valid_token? 

    TokenBlacklist.invalidate(token: auth_token, user_id: auth_token&.user_id)
    UserToken.invalidate(user_id: auth_token&.user_id)
  end
end
