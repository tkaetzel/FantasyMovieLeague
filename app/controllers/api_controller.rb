class ApiController < ApplicationController
	def movie_data
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
		rows = []

		movies.each do |m|
			this_movie_gross = m.earnings.empty? ? 0 : m.earnings.max_by{|a| a.created_at}.gross
			total_shares = m.shares.where(:player_id => players).sum(:num_shares)
			
			this_movie = {
				:id => m.id,
				:movie => m.name,
				:releasedate => m.release_date.strftime("%F"),
				:rating => m.rotten_tomatoes_rating,
				:total => {:earning => this_movie_gross, :shares => total_shares},
				:value => {:earning => this_movie_gross / total_shares}
			}
			
			players.each do |p|
				s = p.shares.select {|s| s.movie_id == m.id}.first
				earning = 0
				if !this_movie_gross.nil? && !this_movie_gross.zero? then
					earning = s.nil? ? 0 : s.num_shares.to_f / total_shares * this_movie_gross
				end
				this_movie[p.short_name] = {
					:earning => earning,
					:shares => s.num_shares
				}
			end
			rows.push this_movie
		end
		
		results = {
			:total => 1,
			:page => 1,
			:records => movies.count,
			:rows => rows
		}
		
		render :json => results
		
	end
	
	def rankings
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
		rows = []

		players.each do |p|
			this_player = {
				:rank => 0,
				:player => p.long_name,
				:pct_in_use => 0,
				:revenue => 0
			}
			
			movies.each do |m|
				this_movie_gross = m.earnings.empty? ? 0 : m.earnings.max_by{|a| a.created_at}.gross
				total_shares = m.shares.where(:player_id => players).sum(:num_shares)
				s = p.shares.select {|s| s.movie_id == m.id}.first
				if !this_movie_gross.nil? && !this_movie_gross.zero? then
					this_player[:revenue] += s.nil? ? 0 : s.num_shares.to_f / total_shares * this_movie_gross
					this_player[:pct_in_use] += s.num_shares if (m.release_date + 1.days) < DateTime.now
				end
			end
			rows.push this_player
		end

		rank = 1
		rows.sort_by! { |a| a[:revenue] }.reverse!
		rows.each do |a|
			a[:rank] = rank
			rank = rank + 1
		end
		
		results = {
			:total => 1,
			:page => 1,
			:records => players.count,
			:rows => rows
		}
		
		render :json => results
	end
	
	def shares
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
			this_movie['Total'] = m.shares.where(:player_id => players).sum(:num_shares)
			this_movie['ReleaseDate'] = m.release_date.strftime("%F")
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
end
