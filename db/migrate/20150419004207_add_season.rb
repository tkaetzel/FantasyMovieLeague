class AddSeason < ActiveRecord::Migration
  def change
	create_table :seasons do |t|
		t.string :name
		t.string :page_title
		t.string :slug
	end
	
	change_table :movies do |t|
		t.references(:season, {:null => false, :default => 0})
	end
	
	change_table :players do |t|
		t.references(:season, {:null => false, :default => 0})
	end
  end
end
