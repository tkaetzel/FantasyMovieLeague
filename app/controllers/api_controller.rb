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
			movies.each do |m|
				this_movie_gross = m.earnings.empty? ? 0 : m.earnings.max_by{|a| a.created_at}.gross
				total_shares = m.shares.where(:player_id => players).sum(:num_shares)
				this_movie_value = total_shares.zero? ? 0 : this_movie_gross / total_shares
				this_movie = {
					"id" => m.id,
					"movie" => m.name,
					"releasedate" => m.release_date.strftime("%F"),
					"rating" => m.rotten_tomatoes_rating.to_s + "%",
					"total" => {"earning" => this_movie_gross, "shares" => total_shares},
					"value" => {"earning" => this_movie_value}
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
			rows.sort_by! { |a| do_sort.call a[params[:sidx]] }
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
			redis.set("rankings:%s" % params[:id], rows.to_json)
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
					this_movie[p.short_name] = share
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
		start_date = @@START_DATE
		stop_date = @@NOW < @@END_DATE ? @@NOW : @@END_DATE
		results = []
		table_data_by_name = {}
		
		while start_date <= stop_date
			until start_date.wday == 0
				start_date += 1
			end
			movies.each do |m|
				earning = m.earnings.select {|e| e.created_at <= start_date}.last
				gross = earning.nil? ? 0 : earning.gross
				total_shares = m.shares.where(:player_id => players).sum(:num_shares)
				
				players.each do |p|
					s = p.shares.select {|s| s.movie_id == m.id}.first
					share = s.nil? ? 0 : s.num_shares.to_f / total_shares * gross

					table_data_by_name[p.long_name] ||= {}
					table_data_by_name[p.long_name][start_date.to_i * 1000] ||= 0
					table_data_by_name[p.long_name][start_date.to_i * 1000] += share
				end
			end
			start_date += 7
		end
		
		table_data_by_name.each do |k,v|
			d = { :name => k, :data => v }
			results.push d
		end
		
		render :json => results
	end
end
