class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable,
    :rememberable, :validatable, :confirmable
  validates :name, presence: true, length: {maximum: Settings.name.maximum}
  validates :email, length: {maximum: Settings.email.maximum}
  validates :password,
    length: {minimum: Settings.password.minimum}, allow_nil: true
  enum role: {admin: 1, normal_user: 2}
end
