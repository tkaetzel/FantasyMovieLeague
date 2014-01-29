class Base < ActiveRecord::Migration
  def change
	create_table :movies do |t|
		t.string :name
		t.string :mapped_name, {default: nil}
		t.text :plot
		t.string :actors
		t.datetime :release_date
		t.string :imdb
	end
	
	create_table :players do |t|
		t.string :long_name
		t.string :short_name
		
		t.timestamps
	end
	
	create_table :teams do |t|
		t.string :name
	end
	
	create_join_table :players, :teams
	
	create_table :shares do |t|
		t.references :player
		t.references :movie
		t.integer :num_shares
	end
	
	create_table :earnings do |t|
		t.references :movie
		t.integer :gross
		
		t.timestamps
	end
  end
end
