# typed: true

module Authentication
  extend ActiveSupport::Concern
  extend T::Sig

  included do
    before_action :require_authentication
    helper_method :current_user, :logged_in?, :admin?
  end

  private

  sig { returns(T.nilable(User)) }
  def current_user
    @current_user ||= current_session&.user
  end

  sig { returns(T.nilable(Session)) }
  def current_session
    return @current_session if defined?(@current_session)

    if session[:session_token].present?
      @current_session = Session.active.find_by(session_token: session[:session_token])

      if @current_session
        @current_session.extend_expiration!
      else
        session.delete(:session_token)
      end
    end

    @current_session
  end

  sig { returns(T::Boolean) }
  def logged_in?
    current_user.present?
  end

  sig { returns(T::Boolean) }
  def admin?
    current_user&.admin? || false
  end

  sig { void }
  def require_authentication
    unless logged_in?
      flash[:alert] = "You must be logged in to access this page."
      redirect_to login_path
    end
  end

  sig { void }
  def skip_authentication
  end

  sig { params(user: User).void }
  def login_user(user)
    user_session = user.sessions.create!
    session[:session_token] = user_session.session_token
    @current_user = user
    @current_session = user_session
  end

  sig { void }
  def logout_user
    current_session&.destroy
    session.delete(:session_token)
    @current_user = nil
    @current_session = nil
  end
end
