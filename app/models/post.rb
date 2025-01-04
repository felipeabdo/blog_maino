class Post < ApplicationRecord
  validates :title, :author, :body, presence: true
  has_many :comments
  has_one_attached :image
end
