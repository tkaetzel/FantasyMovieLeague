class AddUrls < ActiveRecord::Migration
  def change
	create_table :urls do |t|
		t.references(:season, {:null => false})
		t.string :url
	end
	
	reversible do |dir|
		dir.up do
			s = Season.find(5)
			s.urls << Url.new(url: "http://www.boxofficemojo.com/seasonal/?view=releasedate&yr=2015&season=Summer&sort=open&order=DESC&p=.htm&page=1")
			s.urls << Url.new(url: "http://www.boxofficemojo.com/seasonal/?view=releasedate&yr=2015&season=Summer&sort=open&order=DESC&p=.htm&page=2")
			s.urls << Url.new(url: "http://www.boxofficemojo.com/seasonal/?view=releasedate&yr=2015&season=Summer&sort=open&order=DESC&p=.htm&page=3")
		end
	end
	
  end
end
