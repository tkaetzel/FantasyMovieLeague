class AddRottenTomatoesUrlToMovies < ActiveRecord::Migration
  def change
    change_table :movies do |t|
      t.column(:rotten_tomatoes_url, :string)
    end
  end
end
