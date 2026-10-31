class Session < ApplicationRecord
  belongs_to :user

  before_create :generate_session_token
  before_create :set_expiration
  after_create :cleanup_expired_sessions

  scope :active, -> { where("expires_at > ?", Time.current) }
  scope :expired, -> { where("expires_at <= ?", Time.current) }

  def expired?
    expires_at <= Time.current
  end

  # Extends at most once a day so page views don't each write to SQLite.
  def extend_expiration!
    update!(expires_at: 30.days.from_now) if expires_at < 29.days.from_now
  end

  private

  def generate_session_token
    self.session_token = SecureRandom.urlsafe_base64(32)
  end

  def set_expiration
    self.expires_at = 30.days.from_now
  end

  def cleanup_expired_sessions
    Session.expired.delete_all
  end
end
