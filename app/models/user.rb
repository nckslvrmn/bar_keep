# typed: false

class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :items, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  before_save :normalize_username

  # Admin helper methods
  def admin?
    is_admin?
  end

  # Class method to find admin users
  def self.admins
    where(is_admin: true)
  end

  # Class method to find non-admin users
  def self.non_admins
    where(is_admin: false)
  end

  private

  def normalize_username
    self.username = username.downcase.strip
  end
end
