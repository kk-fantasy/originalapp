class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :movie
  #belongs_to :review

  validates :content, presence: { message: "を入力してください" }
end
