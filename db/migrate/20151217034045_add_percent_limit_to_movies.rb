class AddPercentLimitToMovies < ActiveRecord::Migration
  def change
    change_table :movies do |t|
      t.column(:percent_limit, :integer)
    end
    
    reversible do |dir|
      dir.up do
        star_wars1 = Movie.find(142)
        star_wars2 = Movie.find(143)
        
        star_wars1.percent_limit = 60
        star_wars1.mapped_name = 'Star Wars: The Force Awakens'
        star_wars2.percent_limit = 40
        star_wars2.mapped_name = 'Star Wars: The Force Awakens'
        
        star_wars1.save
        star_wars2.save
      end
    end
  end
end
