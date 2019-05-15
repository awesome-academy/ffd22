class User < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :suggestions, dependent: :destroy
  has_many :orders, dependent: :destroy
  devise :database_authenticatable, :registerable, :recoverable,
    :rememberable, :validatable, :confirmable
  validates :name, presence: true, length: {maximum: Settings.name.maximum}
  validates :password,
    length: {minimum: Settings.password.minimum}, allow_nil: true
  enum role: {admin: 0, normal_user: 1}
end
