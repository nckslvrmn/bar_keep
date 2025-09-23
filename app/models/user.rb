# typed: false

class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :items, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  before_save :normalize_username

  def admin?
    is_admin?
  end

  def guest?
    is_guest?
  end

  def self.admins
    where(is_admin: true)
  end

  def self.non_admins
    where(is_admin: false)
  end

  def self.guests
    where(is_guest: true)
  end

  def self.regular_users
    where(is_guest: false, is_admin: false)
  end

  private

  def normalize_username
    self.username = username.downcase.strip
  end
end
