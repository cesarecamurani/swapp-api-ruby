# frozen_string_literal: true

class AuthenticationController < ApplicationController
  skip_before_action :authorize_request
 
  def login
    user = User.find_by(email: params[:email])
    
    unless user&.authenticate(params[:password])
      error = { user_authentication: 'Invalid credentials' }
      return render json: { error: error }, status: :unauthorized
    end

    unless (auth_token = JsonWebToken.encode(payload: { user_id: user.id }))
      raise Error::UnauthorizedError
    end

    render json: auth_response(auth_token, user.id), status: :ok
  end

  def logout
    invalidate_token
    render json: { message: 'You\'ve been logged out' }, status: :ok
  end

  private

  def invalidate_token
    decoded_token = JsonWebToken.decode(token: token)
    TokenBlacklist.invalidate(token: token, user_id: decoded_token[:user_id])
    UserToken.invalidate(user_id: decoded_token[:user_id])
  end
end
