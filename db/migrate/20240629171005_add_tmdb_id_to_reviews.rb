class AddTmdbIdToReviews < ActiveRecord::Migration[7.1]
  def change
    add_column :reviews, :tmdb_id, :integer
  end
end
