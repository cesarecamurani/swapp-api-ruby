# frozen_string_literal: true

module AuthenticationHelpers
  SECRET_KEY = ENV['JWT_SECRET']
  ENCODING = 'HS512'

  def token_for(user_id)
    JWT.encode(
      {
        exp: 30.minutes.from_now.to_i,
        user_id: user_id
      },
      SECRET_KEY,
      ENCODING
    )
  end
end

