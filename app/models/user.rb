class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  # Normalize username to lowercase
  before_save :normalize_username

  private

  def normalize_username
    self.username = username.downcase.strip
  end
end
