# frozen_string_literal: true

class JsonWebToken
  class << self
    SECRET_KEY = ENV['JWT_SECRET']
    ENCODING = 'HS512'

    def encode(payload:, exp: 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY, ENCODING)
    end
 
    def decode(token:)
      decoded_token = JWT.decode(token, SECRET_KEY, ENCODING)[0]
      HashWithIndifferentAccess.new decoded_token
    rescue
      nil
    end
  end
end
