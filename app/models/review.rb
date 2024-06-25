class Review < ApplicationRecord
  belongs_to :movie
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :tags, join_table: "reviews_tags"
end
