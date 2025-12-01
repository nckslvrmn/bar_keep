# typed: true

class User < ApplicationRecord
  extend T::Sig

  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :items, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  before_save :normalize_username

  sig { returns(T::Boolean) }
  def admin?
    is_admin?
  end

  sig { returns(T::Boolean) }
  def guest?
    is_guest?
  end

  sig { returns(ActiveRecord::Relation) }
  def self.admins
    where(is_admin: true)
  end

  sig { returns(ActiveRecord::Relation) }
  def self.non_admins
    where(is_admin: false)
  end

  sig { returns(ActiveRecord::Relation) }
  def self.guests
    where(is_guest: true)
  end

  sig { returns(ActiveRecord::Relation) }
  def self.regular_users
    where(is_guest: false, is_admin: false)
  end

  private

  sig { returns(String) }
  def normalize_username
    self.username = username.downcase.strip
  end
end
