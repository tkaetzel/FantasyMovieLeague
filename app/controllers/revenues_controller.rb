require "net/http"
class RevenuesController < ApplicationController
  def index
	urls = ["http://boxofficemojo.com/seasonal/?page=1&view=releasedate&yr=2013&season=Holiday&sort=open&order=DESC&p=.htm","http://boxofficemojo.com/seasonal/?page=1&view=releasedate&yr=2013&season=Holiday&sort=open&order=DESC&p=.htm&page=2"]
	
	@now = DateTime.now
	@start_date = DateTime.new(2013,11,1,0,0,0,"-4")
	@end_date = DateTime.new(2013,12,25,0,0,0,"-4")
	@season_end_date = @end_date + 4.weeks
		
	db = connect
	del_sql = "DELETE FROM `earnings` WHERE `on_date`='%s'" % @now.strftime("%Y-%m-%d")
	db.query(del_sql)
	
	urls = [] if @now >= @season_end_date
	
	results = db.query("SELECT COALESCE(`mapped_name`, `name`) FROM `movies`")
	movies = []
	results.each do |d|
		movies.push(d.first[1])
	end
	
	urls.each do |url|
		uri = URI(url)
		html = Net::HTTP.get(uri)
		doc = Nokogiri::HTML(html)
		context = doc.xpath "//form[@name='MojoDropDown1']/ancestor::table[2]/tr"
		next if context.nil? or context.empty?
		
		for i in 1..context.length-1 do
			row = context[i]
			o = Movie.new
			o.name = row.xpath("td[3]")[0].content
			o.gross = row.xpath("td[5]")[0].content
			o.theaters = row.xpath("td[6]")[0].content
			o.open = row.xpath("td[9]")[0].content
		end
		
	end
	
  end
end
