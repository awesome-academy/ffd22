class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :children, class_name: Category.name, foreign_key: :parent_id
  validates :name, presence: true, length: {maximum: Settings.name.maximum}
end
