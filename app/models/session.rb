class Session < ApplicationRecord
  belongs_to :user

  before_create :generate_session_token
  before_create :set_expiration

  scope :active, -> { where("expires_at > ?", Time.current) }
  scope :expired, -> { where("expires_at <= ?", Time.current) }

  def expired?
    expires_at <= Time.current
  end

  def extend_expiration!
    update!(expires_at: 30.days.from_now)
  end

  private

  def generate_session_token
    self.session_token = SecureRandom.urlsafe_base64(32)
  end

  def set_expiration
    self.expires_at = 30.days.from_now
  end
end
