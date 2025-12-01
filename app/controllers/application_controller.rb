# typed: true

class ApplicationController < ActionController::Base
  extend T::Sig
  allow_browser versions: :modern unless Rails.env.development?

  include Authentication

  protect_from_forgery with: :exception, prepend: true

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    if request.xhr?
      render json: { error: "CSRF token verification failed" }, status: :unprocessable_entity
    else
      logger.warn "CSRF token verification failed: #{exception.message}"
      logger.warn "User Agent: #{request.user_agent}"
      logger.warn "Request IP: #{request.remote_ip}"

      redirect_to root_path, alert: "Your session has expired. Please sign in again."
    end
  end
end
