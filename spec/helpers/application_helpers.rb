# frozen_string_literal: true

module ApplicationHelpers

  def headers
    {
      "Authorization" => "Bearer #{token_for(user.id)}"
    }
  end

  def response_body
    JSON.parse(response.body)
  end

  def state
    response_body['state']
  end

  def error_message
    response_body['message']
  end
end
