# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Error::ErrorHandler

  skip_before_action :verify_authenticity_token
  before_action :authorize_request

  attr_reader :current_user, :current_swapper

  private

  def auctions
    @auctions ||= current_swapper&.auctions
  end

  def bids
    auction = auctions&.find_by(id: params[:auction_id])
    @bids ||= auction&.bids
  end

  def http_token
    authorization = request.headers['Authorization'].presence ||
                    request['headers']['Authorization'].presence

    return unless authorization

    @http_token ||= authorization.split(' ').last
  end

  def decoded_token
    @decoded_token ||= OpenStruct.new(
      JsonWebToken.decode(token: http_token)
    )
  end

  def valid_token?
    http_token && decoded_token&.user_id
  end

  def authorize_request
    if TokenBlacklist.includes?(token: http_token)
      raise_unauthorized_with('This token has been revoked')
    end

    unless valid_token?
      raise_unauthorized_with('Invalid or missing token')
    end

    unless (@current_user ||= User.find_by(id: decoded_token&.user_id))
      raise_unauthorized_with('No user was found for this token')
    end
  end

  def auth_response(token, user_id, username, email, swapper)
    {
      token_type: 'Bearer',
      auth_token: token,
      user_id: user_id,
      username: username,
      email: email,
      swapper: swapper
    }
  end

  def raise_unauthorized_with(message)
    raise Error::UnauthorizedError.new(message: message)
  end

  def present(object, **options)
    serializer = options[:serializer].presence

    return render json: object, status: options[:status] if serializer.nil?

    response = if object.is_a?(Array)
                 object.map { |obj| serializer.constantize.new(obj) }
               else
                 serializer.constantize.new(object)
               end

    render json: response, status: options[:status]
  end
end
