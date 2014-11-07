require "net/http"

class RevenuesController < ApplicationController
  def index
	urls = ["http://boxofficemojo.com/seasonal/?page=1&view=releasedate&yr=2014&season=Fall&sort=open&order=DESC&p=.htm&page=1",
	"http://boxofficemojo.com/seasonal/?page=1&view=releasedate&yr=2014&season=Holiday&sort=open&order=DESC&p=.htm&page=1","http://boxofficemojo.com/seasonal/?page=1&view=releasedate&yr=2014&season=Holiday&sort=open&order=DESC&p=.htm&page=2"]

	urls = [] if @@NOW >= @@SEASON_END_DATE
	data = []
	queries = ""
	movies = Movie.all
	
	Earning.where("DATE(created_at) = ?", Date.today).destroy_all # to prevent duplicates
	
	urls.each do |url|
		uri = URI(url)
		html = Net::HTTP.get(uri)
		doc = Nokogiri::HTML(html)
		context = doc.xpath "//form[@name='MojoDropDown1']/ancestor::table[2]/tr"
		next if context.nil? or context.empty?
		
		for i in 1..context.length-1 do
			row = context[i]
			begin
				name = row.xpath("td[3]")[0].content
				movie = movies.select {|m| m.name == name || m.mapped_name == name}
				next if movie.empty?
				
				gross = row.xpath("td[5]")[0].content.gsub(/\$|,/,'').to_i
				movie.first.earnings += [Earning.new(gross: gross)]
				queries += "%s: %d\r\n" % [name, gross]
			rescue
				next
			end
		end		
	end
	queries += "\r\n"
	# now get the rotten tomatoes data
	movies = Movie.where("release_date <= date('%s','3 days')" % DateTime.now.strftime('%F'))
	movies.each do |m|
		next if m.rotten_tomatoes_id.nil?
		uri = URI("http://api.rottentomatoes.com/api/public/v1.0/movies/%d.json?apikey=%s" % [m.rotten_tomatoes_id, SECRETS["rotten-tomatoes-api-key"]])
		data = JSON.parse(Net::HTTP.get(uri))
		rating = Integer(data["ratings"]["critics_score"])
		if rating > 0 then
			m.rotten_tomatoes_rating = rating
			queries += "%s: %d%%\r\n" % [m.name, rating]
			m.save
		end
		sleep 0.5
	end
	
	redis = Redis.new
	redis.flushall
	
	output = <<OUTPUT
Now: #{@@NOW.rfc3339}
First Movie Released: #{@@START_DATE.rfc3339}
Last Movie Released: #{@@END_DATE.rfc3339}
Season Ends: #{@@SEASON_END_DATE.rfc3339}

#{queries}
OUTPUT
	render layout: false, text: output, content_type:"text/plain"
	
  end
end