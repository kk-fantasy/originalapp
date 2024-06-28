class Movie < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :comments, dependent: :destroy

  # タグの関連付けをレビューを介して行う
  has_many :tags, through: :reviews

  validates :title, presence: true
  validates :tmdb_id, presence: true, uniqueness: true

  ransack_alias :title, :title

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "id_value", "overview", "poster_path", "poster_url", "release_date", "title", "tmdb_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["comments", "reviews", "tags"]
  end

  def self.create_from_tmdb(movie_id)
    tmdb_client = TmdbClient.new
    movie_data = tmdb_client.fetch_movie_details(movie_id)

    create!(
      title: movie_data['title'],
      description: movie_data['overview'],
      release_date: movie_data['release_date'],
      poster_url: "https://image.tmdb.org/t/p/w500#{movie_data['poster_path']}",
      tmdb_id: movie_data['id']
    )
  end
end