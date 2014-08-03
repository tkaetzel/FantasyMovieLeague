class AddDirectorToMovies < ActiveRecord::Migration
  def change
	add_column :movies, :director, :string
	add_column :movies, :rating, :integer, {default: nil}
  end
end
