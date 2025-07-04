# Configure session cookies to work properly on mobile browsers
# and when the app is launched from home screen (PWA mode)

Rails.application.config.session_store :cookie_store,
  key: "_bar_keep_session",
  expire_after: 30.days,
  secure: Rails.env.production?,
  same_site: :lax,  # Changed from :strict to :lax for better mobile compatibility
  httponly: true
