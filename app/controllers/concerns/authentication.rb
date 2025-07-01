module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :current_user, :logged_in?, :admin?
  end

  private

  def current_user
    @current_user ||= current_session&.user
  end

  def current_session
    return @current_session if defined?(@current_session)

    if session[:session_token].present?
      @current_session = Session.active.find_by(session_token: session[:session_token])

      if @current_session
        # Extend session expiration on activity
        @current_session.extend_expiration!
      else
        # Clear invalid session token
        session.delete(:session_token)
      end
    end

    @current_session
  end

  def logged_in?
    current_user.present?
  end

  def admin?
    current_user&.admin?
  end

  def require_authentication
    unless logged_in?
      flash[:alert] = "You must be logged in to access this page."
      redirect_to login_path
    end
  end

  def skip_authentication
    # This method allows controllers to skip authentication
  end

  def login_user(user)
    user_session = user.sessions.create!
    session[:session_token] = user_session.session_token
    @current_user = user
    @current_session = user_session
  end

  def logout_user
    current_session&.destroy
    session.delete(:session_token)
    @current_user = nil
    @current_session = nil
  end
end
