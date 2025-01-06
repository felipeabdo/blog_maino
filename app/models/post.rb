class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_one_attached :image

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  has_one_attached :file

  validates :title, :body, presence: true, unless: -> { file.attached? }

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end
end
