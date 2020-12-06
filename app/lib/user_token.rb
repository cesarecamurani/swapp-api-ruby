# frozen_string_literal: true

class UserToken
  class << self
    def list(user_id)
      $swapp_namespace.get(user_id).nil? ? [] : JSON.parse($swapp_namespace.get(user_id)).uniq
    end

    def store(token:, user_id:)
      user_token_list = list(user_id)
      user_token_list << token

      $swapp_namespace.set(
        user_id,
        user_token_list.to_json,
        { exp: 1.hour.from_now.to_i }
      )
    end

    def invalidate(user_id:)
      user_token_list = list(user_id)
      user_token_list.each do |token|
        TokenBlacklist.invalidate(token: token, user_id: user_id)
      end
    end
  end
end
