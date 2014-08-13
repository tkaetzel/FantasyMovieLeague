class ApiController < ApplicationController
	def movie_data
		redis = Redis.new
		
		do_sort = Proc.new do |a|
			next a if !a.is_a?(Hash)
			next a["earning"] if !a["earning"].nil? && a["earning"] > 0
			next a["shares"] if !a["shares"].nil? && a["shares"] > 0
			next 0
		end
		
		rows = []
		rows_json = redis.get("movie_data:%s" % params[:team])
		
		if rows_json.nil? then
			players = []

			case (params[:team] || "").downcase
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
			movies.each do |m|
				this_movie_gross = m.earnings.empty? ? 0 : m.earnings.max_by{|a| a.created_at}.gross
				total_shares = m.shares.where(:player_id => players).sum(:num_shares)
				
				this_movie = {
					"id" => m.id,
					"movie" => m.name,
					"releasedate" => m.release_date.strftime("%F"),
					"rating" => m.rotten_tomatoes_rating.to_s + "%",
					"total" => {"earning" => this_movie_gross, "shares" => total_shares},
					"value" => {"earning" => this_movie_gross / total_shares}
				}
				
				players.each do |p|
					s = p.shares.select {|s| s.movie_id == m.id}.first
					earning = 0
					if !this_movie_gross.nil? && !this_movie_gross.zero? then
						earning = s.nil? ? 0 : s.num_shares.to_f / total_shares * this_movie_gross
					end
					this_movie[p.short_name] = {"earning" => earning, "shares" => s.num_shares}
				end
				rows.push this_movie
			end
			redis.set("movie_data:%s" % params[:team], rows.to_json)
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
			rows.sort_by! { |a| do_sort.call a[params[:sidx]] }
			rows.reverse! if params[:sord] == "desc"
		end
		
		render :json => results
		
	end
	
	def rankings
		redis = Redis.new
		
		rows = []
		rows_json = redis.get("rankings:%s" % params[:team])
		
		if rows_json.nil? then
			players = []

			case (params[:team] || "").downcase
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

			best_rating = movies.select {|a| !a[:rotten_tomatoes_rating].nil? }.map { |a| a[:rotten_tomatoes_rating] }.max
			best_movies = movies.select {|a| a[:rotten_tomatoes_rating] == best_rating}.map { |a| a[:id] }

			worst_rating = movies.select {|a| !a[:rotten_tomatoes_rating].nil? }.map { |a| a[:rotten_tomatoes_rating] }.min
			worst_movies = movies.select {|a| a[:rotten_tomatoes_rating] == worst_rating}.map { |a| a[:id] }

			players.each do |p|
				this_player = {
					"rank" => 0,
					"player" => p.long_name,
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
					this_player["player"] += '*'
				end
				if worst_movies.include? p[:bonus2] then
					this_player["revenue"] += 10000000
					this_player["player"] += '*'
				end
		
				rows.push this_player
			end

			rank = 1
			rows.sort_by! { |a| a["revenue"] }.reverse!
			rows.each do |a|
				a["rank"] = rank
				rank = rank + 1
			end
			redis.set("rankings:%s" % params[:team], rows.to_json)
		else
			rows = JSON.parse rows_json
		end
		
		if !params[:sidx].nil? && !params[:sord].nil? then
			rows.sort_by! {|a| a[params[:sidx]]}
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
		rows_json = redis.get("shares:%s" % params[:team])
		if rows_json.nil? then
			players = []

			case (params[:team] || "").downcase
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
					this_movie[p.short_name] = share
				end
				this_movie["movie"] = m.name
				this_movie["total"] = m.shares.where(:player_id => players).sum(:num_shares)
				this_movie["releasedate"] = m.release_date.strftime("%F")
				rows.push this_movie
			end
			redis.set("shares:%s" % params[:team], rows.to_json)
		else
			rows = JSON.parse rows_json
		end
		
		if !params[:sidx].nil? && !params[:sord].nil? then
			rows.sort_by! {|a| a[params[:sidx]]}
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
end
