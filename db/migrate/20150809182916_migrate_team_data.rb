class MigrateTeamData < ActiveRecord::Migration
  def change
    change_table :teams do |t|
	  t.references :season
	  
	  reversible do |dir|
	    dir.up do
		  t = Team.find(1)
		  t.season_id = 1
		  t.save
		  
		  t = Team.find(2)
		  t.name = 'Net Driven'
		  t.season_id = 1
		  t.save
		  
		  Team.create({name: 'Friends', season_id: 2})
		  Team.create({name: 'Net Driven', season_id: 2})
		  
		  Team.create({name: 'Friends', season_id: 3})
		  Team.create({name: 'Net Driven', season_id: 3})
		  
		  Team.create({name: 'Friends', season_id: 4})
		  Team.create({name: 'Net Driven', season_id: 4})
		  
		  Team.create({name: 'Friends', season_id: 5})
		  Team.create({name: 'Net Driven', season_id: 5})
		  
		  change_column_null :teams, :season_id, false # adds not null constraint
		  
		end
	  end
    end
  end
end
