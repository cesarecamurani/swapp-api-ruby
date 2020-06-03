# frozen_string_literal: true

module Error
  module ErrorHandler
    def self.included(klass)
      klass.class_eval do
        rescue_from StandardError do |error|
          log_error(error)
          respond(:standard_error, 500, error.to_s)
        end

        rescue_from UnauthorizedError do |error|
          log_error(error.message)
          respond(:unauthorized, 401, error.message)
        end

        rescue_from ArgumentError do |error|
          log_error(error)
          respond(:unprocessable_entity, 422, error.to_s)
        end

        rescue_from ActiveRecord::RecordNotFound do |error|
          log_error(error)
          respond(:record_not_found, 404, error.to_s)
        end

        rescue_from ActiveRecord::RecordInvalid do |error|
          log_error(error)
          respond(:unprocessable_entity, 422, error.to_s)
        end
      end
    end

    private

    def log_error(error)
      Rails.logger.info "#{error.class}: #{error}"
    end

    def respond(error, status, message)
      error_to_json = Helpers::Render.json(
        error: error, 
        status: status, 
        message: message
      )
      
      render json: error_to_json, status: status
    end
  end
end
