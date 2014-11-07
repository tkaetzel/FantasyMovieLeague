class ApiController < ApplicationController
	def movie_data
		redis = Redis.new

		rows = []
		rows_json = redis.get("movie_data:%s" % params[:id])
		
		if rows_json.nil? then
			players = []

			case (params[:id] || "").downcase
			when 'friends'
				players = Team.find(1).players.includes(:shares)
			when 'work'
				players = Team.find(2).players.includes(:shares)
			when ''
				players = Player.all.includes(:shares)
			else
				render :status => :not_found, :text => ''
				return
			end
			
			movies = Movie.all.includes(:shares, :earnings)
			best_movies, worst_movies = get_best_and_worst_movies(movies)
			
			movies.each do |m|
				this_movie_gross = m.earnings.empty? ? 0 : m.earnings.max_by{|a| a.created_at}.gross
				total_shares = m.shares.where(:player_id => players).sum(:num_shares)
				this_movie_value = total_shares.zero? ? 0 : this_movie_gross / total_shares
				this_movie = {
					"id" => m.id,
					"movie" => m.name,
					"releasedate" => m.release_date.strftime("%F"),
					"rating" => {"rating" => m.rotten_tomatoes_rating, "class" => ""},
					"total" => {"earning" => this_movie_gross, "shares" => total_shares},
					"value" => {"earning" => this_movie_value}
				}
				
				if best_movies.include? m.id && !m.rotten_tomatoes_rating.nil? then
					this_movie["rating"]["class"] = "darkgreen"
				elsif worst_movies.include? m.id && !m.rotten_tomatoes_rating.nil? then
					this_movie["rating"]["class"] = "darkred"
				end
				
				players.each do |p|
					s = p.shares.select {|s| s.movie_id == m.id}.first
					earning = 0
					css_class = ""
					
					if !this_movie_gross.nil? && !this_movie_gross.zero? then
						earning = s.nil? ? 0 : s.num_shares.to_f / total_shares * this_movie_gross					
					end
					
					if best_movies.include?(m.id) && p["bonus1"] == m.id then
						earning += 10000000
						css_class = "darkgreen"
					elsif p["bonus1"] == m.id then
						css_class = "green"
					end
					
					if worst_movies.include?(m.id) && p["bonus2"] == m.id then
						earning += 10000000
						css_class = "darkred"
					elsif p["bonus2"] == m.id then
						css_class = "red"
					end	
					
					this_movie[p.short_name] = {"earning" => earning, "shares" => s.num_shares, "class" => css_class}
					
				end
				rows.push this_movie
			end
			redis.set("movie_data:%s" % params[:id], rows.to_json)
		else
			rows = JSON.parse rows_json
		end
		
		results = {
			"total" => 1,
			"page" => 1,
			"records" => rows.length,
			"rows" => rows
		}

		if !params[:sidx].nil? && !params[:sord].nil? then
			rows.sort_by! { |a| do_sort(a[params[:sidx]]) }
			rows.reverse! if params[:sord] == "desc"
		end
		
		render :json => results
		
	end
	
	def rankings
		redis = Redis.new
		
		rows = []
		rows_json = redis.get("rankings:%s" % params[:id])
		
		if rows_json.nil? then
			players = []

			case (params[:id] || "").downcase
			when 'friends'
				players = Team.find(1).players.includes(:shares)
			when 'work'
				players = Team.find(2).players.includes(:shares)
			when ''
				players = Player.all.includes(:shares)
			else
				render :status => :not_found, :text => ''
				return
			end
			
			movies = Movie.all.includes(:shares, :earnings)
			best_movies, worst_movies = get_best_and_worst_movies(movies)

			players.each do |p|
				this_player = {
					"rank" => 0,
					"player" => {"id" => p.id, "long_name" => p.long_name, "short_name" => p.short_name},
					"pct_in_use" => 0,
					"revenue" => 0
				}
				
				movies.each do |m|
					this_movie_gross = m.earnings.empty? ? 0 : m.earnings.max_by{|a| a.created_at}.gross
					total_shares = m.shares.where(:player_id => players).sum(:num_shares)
					s = p.shares.select {|s| s.movie_id == m.id}.first
					if !this_movie_gross.nil? && !this_movie_gross.zero? then
						this_player["revenue"] += s.nil? ? 0 : s.num_shares.to_f / total_shares * this_movie_gross
						this_player["pct_in_use"] += s.num_shares if (m.release_date + 1.days) < DateTime.now
					end
				end

				if best_movies.include? p[:bonus1] then
					this_player["revenue"] += 10000000
					this_player["player"]["long_name"] += '*'
				end
				if worst_movies.include? p[:bonus2] then
					this_player["revenue"] += 10000000
					this_player["player"]["long_name"] += '*'
				end
		
				rows.push this_player
			end

			rank = 1
			rows.sort_by! { |a| a["revenue"] }.reverse!
			rows.each do |a|
				a["rank"] = rank
				rank = rank + 1
			end
			redis.set("rankings:%s" % params[:id], rows.to_json)
		else
			rows = JSON.parse rows_json
		end
		
		if !params[:sidx].nil? && !params[:sord].nil? then
			rows.sort_by! { |a| do_sort(a[params[:sidx]]) }
			rows.reverse! if params[:sord] == "desc"
		end
		
		results = {
			:total => 1,
			:page => 1,
			:records => rows.length,
			:rows => rows
		}
		
		render :json => results
	end
	
	def shares
		redis = Redis.new
		
		rows = []
		rows_json = redis.get("shares:%s" % params[:id])
		if rows_json.nil? then
			players = []

			case (params[:id] || "").downcase
			when 'friends'
				players = Team.find(1).players.includes(:shares)
			when 'work'
				players = Team.find(2).players.includes(:shares)
			when ''
				players = Player.all.includes(:shares)
			else
				render :status => :not_found, :text => ''
				return
			end
			movies = Movie.all.includes(:shares)
			
			movies.each do |m|
				this_movie = {}
				players.each do |p|
					s = p.shares.select {|s| s.movie_id == m.id}.first
					share = s.nil? ? 0 : s.num_shares
					css_class = p["bonus1"] == m.id ? "green" : p["bonus2"] == m.id ? "red" : ""
					this_movie[p.short_name] = {"shares"=>share, "class"=>css_class}
				end
				this_movie["movie"] = m.name
				this_movie["total"] = m.shares.where(:player_id => players).sum(:num_shares)
				this_movie["releasedate"] = m.release_date.strftime("%F")
				rows.push this_movie
			end
			redis.set("shares:%s" % params[:id], rows.to_json)
		else
			rows = JSON.parse rows_json
		end
		
		if !params[:sidx].nil? && !params[:sord].nil? then
			rows.sort_by! { |a| do_sort(a[params[:sidx]]) }
			rows.reverse! if params[:sord] == "desc"
		end
		
		results = {
			:total => 1,
			:page => 1,
			:records => rows.length,
			:rows => rows
		}
		
		render :json => results
		
	end
	
	def graph_data
		movies = []
		if params[:id].nil? then
			movies = Movie.includes(:earnings)
		else
			movies = Movie.includes(:earnings).where(:id => params[:id].to_i)
		end

		results = []
		
		if movies.empty? then
			render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
			return			
		end
		
		movies.each do |m|
			next if m.earnings.empty?
			
			to_add = {}
			to_add["name"] = m.name
			to_add["data"] = []
			
			m.earnings.each do |e|
				if e == m.earnings.first then
					to_add["data"].push [e.created_at.strftime("%s").to_i * 1000, 0]
				end
				if e.created_at.wday == 0 || e == m.earnings.last then
					to_add["data"].push [e.created_at.strftime("%s").to_i * 1000, e.gross]
				end
			end
			if !to_add.empty? then
				results.push to_add
			end
		end

		render :json => results
	end
	
	def graph_totals
		results = []
		table_data = get_graph_data.first
		table_data.each do |k,v|
			data = v.to_a.map {|a| [a.first, a.last.round]}
			d = { :name => k, :data => data }
			results.push d
		end
		
		render :json => results
	end
	
	def graph_rankings
		results = []
		table_data = get_graph_data.second
		table_data.each do |k,v|
			d = { :name => k, :data => v.to_a }
			results.push d
		end
		
		render :json => results
	end
	
	def graph_spread
		results = []
		table_data = get_graph_data.last
		table_data.each do |k,v|
			data = v.to_a.map {|a| [a.first, a.last.round]}
			d = { :name => k, :data => data }
			results.push d
		end
		
		render :json => results
	end
	
	private
	
	def get_graph_data
		redis = Redis.new
		rows_json = redis.get("graph:%s" % params[:id])
		return JSON.parse rows_json unless rows_json.nil?
		
		players = []

		case (params[:id] || "").downcase
		when 'friends'
			players = Team.find(1).players.includes(:shares)
		when 'work'
			players = Team.find(2).players.includes(:shares)
		when ''
			players = Player.all.includes(:shares)
		else
			render :status => :not_found, :text => ''
			return
		end
		
		movies = Movie.all.includes(:shares, :earnings)
		best_movies, worst_movies = get_best_and_worst_movies(movies)
		
		start_date = @@START_DATE
		stop_date = @@NOW < @@END_DATE ? @@NOW : @@END_DATE
		name, date, rankings, spreads = {}, {}, {}, {}

		while start_date <= stop_date
			until start_date.wday == 0
				start_date += 1
			end
			timestamp = start_date.to_i * 1000
			movies.each do |m|
				earning = m.earnings.select {|e| e.created_at <= start_date}.last
				gross = earning.nil? ? 0 : earning.gross
				total_shares = m.shares.where(:player_id => players).sum(:num_shares)
				
				players.each do |p|
					s = p.shares.select {|s| s.movie_id == m.id}.first
					share = s.nil? ? 0 : s.num_shares.to_f / total_shares * gross

					if m == movies.first then
						share += 10000000 if best_movies.include? p[:bonus1]
						share += 10000000 if worst_movies.include? p[:bonus2]
					end
					
					name[p.long_name] ||= {}
					name[p.long_name][timestamp] ||= 0
					name[p.long_name][timestamp] += share
					
					date[timestamp] ||= {}
					date[timestamp][p.long_name] ||= 0
					date[timestamp][p.long_name] += share					
				end
			end
			
			i=0
			s_min = date[timestamp].min_by(&:last)[1]
			spread = date[timestamp].max_by(&:last)[1] - s_min
			date[timestamp].sort_by {|a| a.last}.reverse.each do |k,v|
				i+=1
				rankings[k] ||= {}
				spreads[k] ||= {}
				rankings[k][timestamp] = i
				spreads[k][timestamp] = (v - s_min)/spread * 100
			end
			
			start_date += 7
		end
		
		rows = [
			name.map {|a| [a.to_a.first, a.to_a.last.to_a]},
			rankings.map {|a| [a.to_a.first, a.to_a.last.to_a]},
			spreads.map {|a| [a.to_a.first, a.to_a.last.to_a]}]

		redis.set("graph:%s" % params[:id], rows.to_json)
		
		return rows
	end

	def get_best_and_worst_movies(movies)
		return [[],[]] unless movies.any? {|m| !m.rotten_tomatoes_rating.nil? }
		best_rating = movies.select {|a| !a[:rotten_tomatoes_rating].nil? }.map { |a| a[:rotten_tomatoes_rating] }.max
		best_movies = movies.select {|a| a[:rotten_tomatoes_rating] == best_rating}.map { |a| a[:id] }

		worst_rating = movies.select {|a| !a[:rotten_tomatoes_rating].nil? }.map { |a| a[:rotten_tomatoes_rating] }.min
		worst_movies = movies.select {|a| a[:rotten_tomatoes_rating] == worst_rating}.map { |a| a[:id] }
		
		return [best_movies, worst_movies]
	end
	
	def do_sort(a)
		return a if !a.is_a?(Hash)
		return a["rating"] if !a["rating"].nil? && a["rating"] > 0
		return a["earning"] if !a["earning"].nil? && a["earning"] > 0
		return a["shares"] if !a["shares"].nil? && a["shares"] > 0
		return a["long_name"] if !a["long_name"].nil?
		return 0
	end
end