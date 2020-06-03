# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Error::ErrorHandler

  skip_before_action :verify_authenticity_token
  before_action :authenticate_request
  
  attr_reader :current_user

  private

  def auth_headers
    request.headers['Authorization']
  end

  def token
    auth_headers&.split(' ')&.last
  end

  def auth_response(token, user_id)
    {
      token_type: 'Bearer',
      auth_token: token,
      user_id: user_id
    }
  end

  def authenticate_request
    raise Error::UnauthorizedError if TokenBlacklist.lists?(token: token)

    decoded = JsonWebToken.decode(token: token)
    
    @current_user ||= User.find_by(id: decoded[:user_id])

    raise Error::UnauthorizedError unless @current_user
  end

  def present(object, **options)
    serializer = options[:serializer].presence
    
    return render json: object, status: options[:status] if serializer.nil?

    response = if object.is_a?(Array)
                 object.map { |obj| serializer.constantize.new(obj) }
               else
                 serializer.constantize.new(object)
               end

    render json: { data: response }, status: options[:status]
  end
end
