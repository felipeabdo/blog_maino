class Post < ApplicationRecord
  validates :title, :body, presence: true  
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_one_attached :image

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end
end
