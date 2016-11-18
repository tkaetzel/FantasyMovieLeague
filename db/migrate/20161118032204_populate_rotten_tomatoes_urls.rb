class PopulateRottenTomatoesUrls < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        m = Movie.find(180); m.rotten_tomatoes_url = 'https://www.rottentomatoes.com/m/doctor_strange_2016'; m.save
        m = Movie.find(181); m.rotten_tomatoes_url = 'https://www.rottentomatoes.com/m/hacksaw_ridge'; m.save
        m = Movie.find(182); m.rotten_tomatoes_url = 'https://www.rottentomatoes.com/m/trolls'; m.save
        m = Movie.find(184); m.rotten_tomatoes_url = 'https://www.rottentomatoes.com/m/billy_lynns_long_halftime_walk'; m.save
        m = Movie.find(185); m.rotten_tomatoes_url = 'https://www.rottentomatoes.com/m/fantastic_beasts_and_where_to_find_them'; m.save
        m = Movie.find(186); m.rotten_tomatoes_url = 'https://www.rottentomatoes.com/m/the_edge_of_seventeen'; m.save
        m = Movie.find(187); m.rotten_tomatoes_url = 'https://www.rottentomatoes.com/m/moana_2016'; m.save
        m = Movie.find(188); m.rotten_tomatoes_url = 'https://www.rottentomatoes.com/m/allied'; m.save
        m = Movie.find(189); m.rotten_tomatoes_url = 'https://www.rottentomatoes.com/m/live_by_night'; m.save
        m = Movie.find(190); m.rotten_tomatoes_url = 'https://www.rottentomatoes.com/m/kidnap_2017'; m.save
        m = Movie.find(191); m.rotten_tomatoes_url = 'https://www.rottentomatoes.com/m/la_la_land'; m.save
        m = Movie.find(192); m.rotten_tomatoes_url = 'https://www.rottentomatoes.com/m/office_christmas_party'; m.save
        m = Movie.find(193); m.rotten_tomatoes_url = 'https://www.rottentomatoes.com/m/miss_sloane'; m.save
        m = Movie.find(194); m.rotten_tomatoes_url = 'https://www.rottentomatoes.com/m/rogue_one_a_star_wars_story'; m.save
        m = Movie.find(195); m.rotten_tomatoes_url = 'https://www.rottentomatoes.com/m/collateral_beauty'; m.save
        m = Movie.find(196); m.rotten_tomatoes_url = 'https://www.rottentomatoes.com/m/passengers_2016'; m.save
        m = Movie.find(197); m.rotten_tomatoes_url = 'https://www.rottentomatoes.com/m/sing_2016'; m.save
        m = Movie.find(198); m.rotten_tomatoes_url = 'https://www.rottentomatoes.com/m/assassins_creed'; m.save
        m = Movie.find(199); m.rotten_tomatoes_url = 'https://www.rottentomatoes.com/m/fences_2016'; m.save
        m = Movie.find(200); m.rotten_tomatoes_url = 'https://www.rottentomatoes.com/m/gold_2016'; m.save
        m = Movie.find(201); m.rotten_tomatoes_url = 'https://www.rottentomatoes.com/m/why_him'; m.save
      end
      
      dir.down do
        m = Movie.find(180); m.rotten_tomatoes_url = nil; m.save
        m = Movie.find(181); m.rotten_tomatoes_url = nil; m.save
        m = Movie.find(182); m.rotten_tomatoes_url = nil; m.save
        m = Movie.find(184); m.rotten_tomatoes_url = nil; m.save
        m = Movie.find(185); m.rotten_tomatoes_url = nil; m.save
        m = Movie.find(186); m.rotten_tomatoes_url = nil; m.save
        m = Movie.find(187); m.rotten_tomatoes_url = nil; m.save
        m = Movie.find(188); m.rotten_tomatoes_url = nil; m.save
        m = Movie.find(189); m.rotten_tomatoes_url = nil; m.save
        m = Movie.find(190); m.rotten_tomatoes_url = nil; m.save
        m = Movie.find(191); m.rotten_tomatoes_url = nil; m.save
        m = Movie.find(192); m.rotten_tomatoes_url = nil; m.save
        m = Movie.find(193); m.rotten_tomatoes_url = nil; m.save
        m = Movie.find(194); m.rotten_tomatoes_url = nil; m.save
        m = Movie.find(195); m.rotten_tomatoes_url = nil; m.save
        m = Movie.find(196); m.rotten_tomatoes_url = nil; m.save
        m = Movie.find(197); m.rotten_tomatoes_url = nil; m.save
        m = Movie.find(198); m.rotten_tomatoes_url = nil; m.save
        m = Movie.find(199); m.rotten_tomatoes_url = nil; m.save
        m = Movie.find(200); m.rotten_tomatoes_url = nil; m.save
        m = Movie.find(201); m.rotten_tomatoes_url = nil; m.save
      end
    end
  end
end