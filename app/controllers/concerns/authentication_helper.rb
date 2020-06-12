# frozen_string_literal: true

module AuthenticationHelper
  extend ActiveSupport::Concern

  private

  def invalidate_token
    raise_unauthorized_with('Invalid or missing token') unless valid_token? 

    TokenBlacklist.invalidate(token: auth_token, user_id: auth_token&.user_id)
    UserToken.invalidate(user_id: auth_token&.user_id)
  end
end
