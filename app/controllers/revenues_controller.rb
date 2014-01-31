require "net/http"

class RevenuesController < ApplicationController
  def index
	urls = ["http://boxofficemojo.com/seasonal/?page=1&view=releasedate&yr=2013&season=Holiday&sort=open&order=DESC&p=.htm","http://boxofficemojo.com/seasonal/?page=1&view=releasedate&yr=2013&season=Holiday&sort=open&order=DESC&p=.htm&page=2"]
		
	Mysql2::Client.default_query_options[:connect_flags] |= Mysql2::Client::MULTI_STATEMENTS
	db = connect
	del_sql = "DELETE FROM `earnings` WHERE `on_date`='%s'" % $NOW.strftime("%Y-%m-%d")
	db.query(del_sql)
	
	urls = [] if $NOW >= $SEASON_END_DATE
	
	results = db.query("SELECT COALESCE(`mapped_name`, `name`) FROM `movies`")
	movies = []
	earnings = []
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
			begin
				o = Movie.new
				o.name = row.xpath("td[3]")[0].content
				o.gross = row.xpath("td[5]")[0].content
				o.theaters = row.xpath("td[6]")[0].content
				o.open = row.xpath("td[9]")[0].content
				
				earnings.push o if movies.member? o.name
				
			rescue
				next
			end
		end		
	end
	@queries = ""
	earnings.each do |o|
		@queries += "INSERT INTO `earnings` (`movie_id`,`gross`,`on_date`) SELECT `id`, %d, \"%s\" FROM `movies` WHERE `name` LIKE \"%s\" OR `mapped_name` LIKE \"%s\";\r\n" % [o.gross, $NOW.strftime("%Y-%m-%d"), o.name, o.name]
	end
	db.query @queries
  end
end
