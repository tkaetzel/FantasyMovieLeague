class AddSlugToTeam < ActiveRecord::Migration
  def change
    change_table :teams do |t|
		t.column(:slug, :string, default:'', null: false)
	end
  end
end