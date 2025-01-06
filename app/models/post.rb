class Post < ApplicationRecord
  validates :title, :body, presence: true  
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_one_attached :image
end
