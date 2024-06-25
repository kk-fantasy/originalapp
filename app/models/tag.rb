class Tag < ApplicationRecord
    has_and_belongs_to_many :reviews, join_table: "reviews_tags"
    has_many :movie_tags
    has_many :movies, through: :movie_tags
    validates :name, presence: true, uniqueness: true
end
