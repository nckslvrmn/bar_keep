# typed: false

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern unless Rails.env.development?

  include Authentication

  # Custom CSRF token handling for better mobile compatibility
  protect_from_forgery with: :exception, prepend: true

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    if request.xhr?
      render json: { error: "CSRF token verification failed" }, status: :unprocessable_entity
    else
      logger.warn "CSRF token verification failed: #{exception.message}"
      logger.warn "User Agent: #{request.user_agent}"
      logger.warn "Request IP: #{request.remote_ip}"

      # Since login has its own CSRF handling, this will only trigger for other pages
      redirect_to root_path, alert: "Your session has expired. Please sign in again."
    end
  end
end
