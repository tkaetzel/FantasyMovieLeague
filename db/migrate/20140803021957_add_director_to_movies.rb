class AddDirectorToMovies < ActiveRecord::Migration
  def change
	add_column :movies, :director, :string
	add_column :movies, :rating, :integer, {default: nil}
	add_column :movies, :rotten_tomatoes_id, :integer
	add_column :movies, :rotten_tomatoes_rating, :integer, {default: nil}
  end
end
