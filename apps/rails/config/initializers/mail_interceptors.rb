# frozen_string_literal: true

Rails.application.configure do
  config.action_mailer.interceptors = %w[UndeliverableEmailInterceptor]
end
