# frozen_string_literal: true

class TokenBlacklist
  class << self
    def list_includes?(token:)
      !$swapp_namespace.get(token).nil?
    end

    def invalidate(token:, user_id:)
      $swapp_namespace.set(
        token, 
        user_id, 
        { exp: 1.hour.from_now.to_i }
      )
    end
  end
end
