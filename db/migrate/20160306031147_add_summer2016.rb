class AddSummer2016 < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        season = Season.create(name:'Summer 2016', page_title:'Fantasy Movie League | Summer 2016', slug:'2016s', bonus_amount: 10000000, new_header_content:'TODO')
        Team.create(name:'Friends', slug:'friends', season_id: season.id)
        Team.create(name:'Net Driven', slug:'net-driven', season_id: season.id)
        Team.create(name:'DealerOn', slug:'dealeron', season_id: season.id)
        Team.create(name:'Urban Science', slug:'urban-science', season_id: season.id)
      end
      
      dir.down do
        season = Season.where(name: 'Summer 2016').first
        Team.where(season_id: season.id).destroy_all
        Season.destroy(season.id)
      end
    end
  end
end
