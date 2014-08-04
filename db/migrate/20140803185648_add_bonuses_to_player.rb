class AddBonusesToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :bonus1, :int
    add_column :players, :bonus2, :int
  end
end
