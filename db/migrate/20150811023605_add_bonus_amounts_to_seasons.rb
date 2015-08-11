class AddBonusAmountsToSeasons < ActiveRecord::Migration
  def change
    change_table :seasons do |t|
		t.column(:bonus_amount, :integer, default:0, null: false)
	end
	
	reversible do |dir|
	  dir.up do
	    s = Season.find(4)
		s.bonus_amount = 10_000_000
		s.save
		
	    s = Season.find(5)
		s.bonus_amount = 10_000_000
		s.save
	  end
	end
  end
end
