class CreateMovies < ActiveRecord::Migration[7.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :description
      t.date :release_date
      t.string :poster_url
      t.integer :tmdb_id

      t.timestamps
    end
  end
end
