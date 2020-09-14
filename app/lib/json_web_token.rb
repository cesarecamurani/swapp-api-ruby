# frozen_string_literal: true

class JsonWebToken
  class << self
    SECRET_KEY = ENV['JWT_SECRET']
    VERIFY = true
    ENCODING = 'HS512'

    def encode(payload:, exp: 1.hour.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY, ENCODING)
    end

    def decode(token:)
      decoded_token = JWT.decode(
        token,
        SECRET_KEY,
        VERIFY,
        algorithm: ENCODING
      ).first

      HashWithIndifferentAccess.new(decoded_token)
    rescue
      nil
    end
  end
end
