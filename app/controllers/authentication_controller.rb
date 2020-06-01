# frozen_string_literal: true

class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request
 
  def login
    auth_request = AuthenticateUser.call(
      email: params[:email], 
      password: params[:password]
    )
 
    if auth_request.success?
      render json: { auth_token: auth_request.result }
    else
      render json: { error: auth_request.errors }, status: :unauthorized
    end
  end

  def logout
    
  end
end
