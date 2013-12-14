
class MainController < ApplicationController
	
	# constants
	COL_HEADER = "'%s', "
	COL_MODEL = "{name:'%s', align:'right', index:'%s', width:45, sorttype:sortMoney},\r\n"
	SHARES_COL_MODEL = "{name:'%s', align:'right', index:'%s', width:45, sorttype:'int'},\r\n"
	FOOTER_TEMPLATE = '<a href="#" onclick="popupDetails(&quot;/graph/breakdown?contestant=%s&amp;data=%s&quot;);return false;">%s</a>'
	COL_HEADER_SHARES = "'%s', "
	COL_MODEL_SHARES = "{name:'%s', align:'right', index:'%s', width:35, sorttype:'int'},\r\n"
	
  def index
	$output = ""
	$START_DATE = DateTime.new(2013,11,1,0,0,0,'-4')
	$NOW = DateTime.now
	
	if $NOW < $START_DATE then
		redirect_to 'http://www.google.com'
	end

	case (params[:team] || "").downcase
	when 'friends'
		@team = 1
	when 'work'
		@team = 2
	when ''
		@team = 0
	else
		render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
		return
	end
	
	percentages = {}
	grosses = {}
	long_names = {}
	shares = {}
	shares_in_use = {}
	release_dates = {}
	
	db = connect
	results = db.query("CALL GetPercentages(#{@team})")
	
	results.each do |row|
		percentages[row["name"]] = row.except("name")
	end
	
	db.close
	db = connect
		results = db.query("CALL GetShares(#{@team})")
	
	results.each do |row|
		shares[row["Movie"]] = row.except("Movie")
	end
	
	db.close
	db = connect
	
	results = db.query("CALL GetNewestGross()")
	
	results.each do |row|
		grosses[row["name"]] = (row.except("name"))["gross"]
	end

	db.close
	db = connect
	
	results = db.query("SELECT * FROM `players`")
	
	results.each do |row|
		long_names[row["short_name"]] = row["long_name"]
	end
	
	db.close
	db = connect
		results = db.query("CALL GetSharesInUse(#{@team})")
	
	results.each do |row|
		shares_in_use[row["name"]] = row["pct_in_use"]
	end
	
	db.close
	
	results = {}
	results_by_movie = {}

	percentages.each do |movie,pct|
		# movie = key (movie title)
		# pct = value (array of ownage percentages for $movie by each user)

		next if grosses[movie].nil?

		total = grosses[movie]
		
		# now for this movie, iterate over the players who own some part of it
		pct.each do |player, owned_pct|
			# player = key (player's short name)
			# owned_pct = value (percentage of $movie that $player owns)
			
			results[player] ||= Hash.new
			results_by_movie[movie] ||= Hash.new
			
			results[player][movie] = owned_pct * total
			results_by_movie[movie][player] = owned_pct * total
			
		end
	end

	sums = {}
	sums_display = {} # this hash will be the same as sums except with html formatting
	standings = []
	$col_headers = ""
	$col_models = ""
	
	results.each do |player,totals|
		sums[player] = totals.values.sum
	end
	sums = Hash[(sums.sort_by &:last).reverse]

	sums.each do |player,total|
		full_name = long_names[player]
		
		sums_display[player] = FOOTER_TEMPLATE % [URI.escape(full_name), URI.escape(Base64.encode64(JSON.generate(results[player]))), to_currency(total)]
		$col_headers += COL_HEADER % player
		$col_models += COL_MODEL % [player, player]
	end
	
	$col_headers = $col_headers.html_safe
	$col_models = $col_models.html_safe
		
	sums_display["movie"] = "<a href=\"#\" onclick=\"popupDetails('/graph/details');return false;\">Total</a>"
	i=0
	results_by_movie.each do |movie,data|
		if !$output.empty? then 
			$output += "," 
		end
		
		$output += "{'id':%d, 'movie':\"%s\", 'releasedate':'%s'" % [i+=1, movie, shares[movie]["ReleaseDate"]]
		total = 0
		data.each do |player,revenue|
			total += revenue
			$output += ",'%s':'%s'" % [player, to_currency(revenue)]
		end
		
		value = total / shares[movie]["Total"]
		
		$output += ", 'total':'%s'" % to_currency(total)
		$output += ", 'value':'%s'}" % to_currency(value)
		
	end
	
	$output = ("[%s]" % $output).html_safe
	$output_sums = JSON.generate(sums_display).html_safe
	
	i=0
	sums.each do |player,score|
		next if long_names[player].empty?
		i+=1
		a = Ranking.new
		a.rank = i
		a.player = long_names[player]
		a.revenue = score
		a.pct_in_use = shares_in_use[player]

		standings.push(a)
	end
	
	$output_rankings = JSON.generate(standings).html_safe

  end
  
  def shares
	
	case (params[:team] || "").downcase
	when 'friends'
		@team = 1
	when 'work'
		@team = 2
	when ''
		@team = 0
	else
		render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
		return
	end
	
	$col_headers = ""
	$col_models = ""
	$json_data = ""
	
	db = connect
	shares = {}
	results = db.query("CALL GetShares(#{@team})")
	
	results.each do |row|
		shares[row["Movie"]] = row.except("Movie")
	end
	db.close
	
	i=1
	names = []
	json = []
	shares.each do |movie,data|
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
