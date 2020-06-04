# frozen_string_literal: true

module Error
  class UnauthorizedError < StandardError
    attr_reader :error, :status, :message

    def initialize(error: 401, status: :unauthorized, message: 'Not Authorized')
      @error = error 
      @status = status
      @message = message
    end
  end
end
