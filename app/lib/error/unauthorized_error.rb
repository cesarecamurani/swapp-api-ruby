# frozen_string_literal: true

module Error
  class UnauthorizedError < StandardError
    attr_reader :error, :status, :message

    def initialize(error = nil, status = nil, message = nil)
      @error = error || 401
      @status = status || :unauthorized
      @message = message || 'Not Authorized'
    end
  end
end
