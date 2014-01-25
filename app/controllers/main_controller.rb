
class MainController < ApplicationController
	# constants
	COL_HEADER = "'%s', "
	COL_MODEL = "{name:'%s', align:'right', index:'%s', width:45, sorttype:sortMoney},\r\n"
	SHARES_COL_MODEL = "{name:'%s', align:'right', index:'%s', width:45, sorttype:'int'},\r\n"
	FOOTER_TEMPLATE = '<a href="#" onclick="popupDetails(&quot;/graph/breakdown&quot;);return false;">%s</a>'
	COL_HEADER_SHARES = "'%s', "
	COL_MODEL_SHARES = "{name:'%s', align:'right', index:'%s', width:35, sorttype:'int'},\r\n"
	
  def index
	$output = ""
	$START_DATE = DateTime.new(2013,11,1,0,0,0,'-4')
	$NOW = DateTime.now
	
	if $NOW < $START_DATE then
		redirect_to 'http://www.google.com'
	end

	players = []
	
	case (params[:team] || "").downcase
	when 'friends'
		players = Team.find(1).players.includes(:shares)
	when 'work'
		players = Team.find(2).players.includes(:shares)
	when ''
		players = Player.all.includes(:shares)
	else
		render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
		return
	end
	
	movies = Movie.all.includes(:shares, :earnings)
	
	grosses = {}
	results_by_movie = {}
	sums = {}
	
	movies.each do |m|
		grosses[m.name] = m.earnings.empty? ? 0 : m.earnings.max_by{|a| a.created_at}.gross
		
		total_shares = m.shares.where(:player_id => players).sum(:num_shares)
		this_movie = {}
		players.each do |p|
			s = p.shares.select {|s| s.movie_id == m.id}.first
			share = s.nil? ? 0 : s.num_shares.to_f / total_shares * grosses[m.name]
			
			sums[p] ||= 0
			this_movie[p] = share
			sums[p] += share
		end
		results_by_movie[m] = this_movie
	end
	sums = Hash[(sums.sort_by &:last).reverse]
	
	sums_display = {} # this hash will be the same as sums except with html formatting
	standings = []
	$col_headers = ""
	$col_models = ""

	sums.each do |player,total|
		sums_display[player.short_name] = FOOTER_TEMPLATE % [to_currency(total)]
		$col_headers += COL_HEADER % player.short_name
		$col_models += COL_MODEL % [player.short_name, player.short_name]
	end
	
	$col_headers = $col_headers.html_safe
	$col_models = $col_models.html_safe
		
	sums_display["movie"] = "<a href=\"#\" onclick=\"popupDetails('/graph/details');return false;\">Total</a>"
	i=0
	release_dates = {} # save these to prevent future processing
	results_by_movie.each do |m,data|
		if !$output.empty? then 
			$output += "," 
		end
		release_dates[m.id] = m.release_date
		$output += "{'id':%d, 'movie':\"%s\", 'releasedate':'%s'" % [i+=1, m.name, m.release_date.strftime("%Y-%m-%d")]
		total = 0
		data.each do |player,revenue|
			total += revenue
			$output += ",'%s':'%s'" % [player.short_name, to_currency(revenue)]
		end
		
		value = total / m.shares.sum(:num_shares)
		
		$output += ", 'total':'%s'" % to_currency(total)
		$output += ", 'value':'%s'}" % to_currency(value)
		
	end
	
	$output = ("[%s]" % $output).html_safe
	$output_sums = JSON.generate(sums_display).html_safe
	
	i=0
	sums.each do |p,score|
		i+=1
		a = Ranking.new
		a.rank = i
		a.revenue = score
		a.pct_in_use = 0

		p.shares.each do |s|
			a.pct_in_use += s.num_shares if release_dates[s.movie_id] < DateTime.now
		end

		a.player = p.long_name
		standings.push(a)
	end
	
	$output_rankings = JSON.generate(standings).html_safe

  end
  
  def shares
	case (params[:team] || "").downcase
	when 'friends'
		players = Team.find(1).players
	when 'work'
		players = Team.find(2).players
	when ''
		players = Player.all
	else
		render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
		return
	end
	
	movies = Movie.all
	
	$col_headers = ""
	$col_models = ""
	$json_data = ""
	shares_by_movie = {}
	
	movies.each do |m|
		this_movie = {}
		players.each do |p|
			s = p.shares.find_by_movie_id(m.id)
			share = s.nil? ? 0 : s.num_shares
			this_movie[p.short_name] = share
		end
		this_movie['Total'] = m.shares.where(:player_id => players).sum(:num_shares)
		this_movie['ReleaseDate'] = m.release_date.strftime("%Y-%m-%d")
		shares_by_movie[m.name] = this_movie
	end
	
	i=1
	names = []
	json = []
	shares_by_movie.each do |movie,data|
		row = { 
			:id => i+=1,
			:movie => movie,
			:total => data["Total"],
			:releasedate => data["ReleaseDate"]
		}
		
		data.each do |player,share_count|
			next if player == "Total" or player == "ReleaseDate"
			names.push(player) if not names.include?(player)
			
			row[player] = share_count
		end
		json.push(row)
	end
	
	names.sort.each do |n|
		$col_headers += COL_HEADER_SHARES % n
		$col_models += COL_MODEL_SHARES % [n,n]
	end
	
	$col_headers = $col_headers.html_safe
	$col_models = $col_models.html_safe
	$json_data = JSON.generate(json).html_safe
  end
  
  def to_currency(a, figures=3)
	ret = ""
	figures -= 1
	if a >= 1000000000 then
		fig = (figures - Math.log10(a/1000000000)).ceil
		ret = (a/1000000000).round(fig).to_s + "b"
	elsif a >= 1000000 then
		fig = (figures - Math.log10(a/1000000)).ceil
		ret = (a/1000000).round(fig).to_s + "m"
	elsif a >= 1000 then
		fig = (figures - Math.log10(a/1000)).ceil
		ret = (a/1000).round(fig).to_s + "k"
	end

	ret = ret.gsub(/\.0([bmk])$/,"\\1")
	
	return ret
  end
  
end
