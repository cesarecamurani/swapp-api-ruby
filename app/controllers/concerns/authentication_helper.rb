# frozen_string_literal: true

module AuthenticationHelper
  extend ActiveSupport::Concern

  private

  def invalidate_token
    raise_unauthorized_with('Invalid or missing token') unless valid_token?

    TokenBlacklist.invalidate(token: http_token, user_id: decoded_token&.user_id)

    UserToken.invalidate(user_id: decoded_token&.user_id)
  end
end
