class AddOverviewToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :overview, :text
  end
end
