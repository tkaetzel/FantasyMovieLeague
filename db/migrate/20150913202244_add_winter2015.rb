class AddWinter2015 < ActiveRecord::Migration
  def change
    change_table :seasons do |t|
      t.column(:new_header_content, :string)
    end
    
    reversible do |dir|
      dir.up do
        season = Season.create(name:'Winter 2015', page_title:'Winter 2015 Movie Contest', slug:'2015w', bonus_amount: 5000000)
        Team.create(name:'Friends', slug:'friends', season_id: season.id)
        Team.create(name:'Net Driven', slug:'net-driven', season_id: season.id)
        Team.create(name:'DealerOn', slug:'dealeron', season_id: season.id)
        Team.create(name:'Urban Science', slug:'urban-science', season_id: season.id)
      end
      
      dir.down do
        season = Season.where(name: 'Winter 2015').first
        Team.where(season_id: season.id).destroy_all
        Season.destroy(season.id)
      end
    end
  end
end
