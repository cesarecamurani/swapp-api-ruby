# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Error::ErrorHandler

  skip_before_action :verify_authenticity_token
  before_action :authorize_request
  
  attr_reader :current_user, :current_swapper

  private

  def current_swapper
    @_current_swapper ||= @current_user.swapper
  end

  def auctions
    @_auctions ||= current_swapper&.auctions
  end

  def bids
    auction = auctions&.find_by(id: params[:auction_id])
    @_bids ||= auction&.bids
  end

  def http_token
    return unless request.headers['Authorization'].present?
    @_http_token ||= request.headers['Authorization'].split(' ').last
  end

  def auth_token
    @_auth_token ||= OpenStruct.new(
      JsonWebToken.decode(token: http_token)
    )
  end

  def valid_token?
    http_token && auth_token&.user_id
  end

  def authorize_request
    if TokenBlacklist.includes?(token: auth_token)
      raise_unauthorized_with('This token has been revoked')
    end
    
    unless valid_token?
      raise_unauthorized_with('Invalid or missing token')
    end
    
    unless (@current_user ||= User.find_by(id: auth_token&.user_id))
      raise_unauthorized_with('No user was found for this token')
    end
  end

  def auth_response(token, user_id)
    {
      token_type: 'Bearer',
      auth_token: token,
      user_id: user_id
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

    render json: { object: response }, status: options[:status]
  end
end
