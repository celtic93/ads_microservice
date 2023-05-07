# frozen_string_literal: true

module ApiErrors
  def handle_exception(error)
    case error
    when Sequel::NoMatchingRow
      error_response(I18n.t(:not_found, scope: 'api.errors'), 404)
    when Sequel::UniqueConstraintViolation
      error_response(I18n.t(:not_unique, scope: 'api.errors'), 422)
    when Sequel::ValidationFailed
      error_response(error.model.errors, 422)
    else
      raise
    end
  end

  private

  def error_response(error_messages, status)
    errors = case error_messages
             when Sequel::Model
               ErrorSerializer.from_model(error_messages)
             else
               ErrorSerializer.from_messages(error_messages)
             end

    { errors: errors, status: status }
  end
end
