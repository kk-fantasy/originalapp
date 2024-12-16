class Review < ApplicationRecord
  belongs_to :movie
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :tags, join_table: "reviews_tags"
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  def likes_count
    self.likes.count
  end
end
