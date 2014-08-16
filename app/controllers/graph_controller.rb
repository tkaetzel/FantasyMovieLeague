class GraphController < ApplicationController
  def get_graph
	$title = ""
	$min = 0
	$reversed = ""
	$graph_output = ""
	
	case (params[:type] || "").downcase
	when 'rank'
		@graph_type = 1
	when 'weekly'
		@graph_type = 0
	when 'spread'
		@graph_type = 2
	else
		render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
		return		
	end
	
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
	
	start_date = DateTime.new(2014,4,6,0,0,0,'-4')
	now = DateTime.now
	stop_date = DateTime.new(2014,9,5,0,0,0,'-4')
	table_data = {}
	table_data_by_name = {}
	table_data_rankings = {}
	
	movies = Movie.all.includes(:shares, :earnings)
	stop_date = now if now < stop_date
	
	while start_date < stop_date
		sums = {}
		table_data_by_date = {}
		movies.each do |m|
			earnings_by_date = m.earnings.select {|e| e.created_at.to_date <= start_date}
			earnings = earnings_by_date.empty? ? 0 : earnings_by_date.max_by{|a| a.created_at}.gross
			
			total_shares = m.shares.where(:player_id => players).sum(:num_shares)
			players.each do |p|
				s = p.shares.select {|s| s.movie_id == m.id}.first
				share = s.nil? ? 0 : s.num_shares.to_f / total_shares * earnings

				table_data_by_name[p.long_name] ||= {}
				table_data_by_name[p.long_name][start_date] ||= 0
				table_data_by_name[p.long_name][start_date] += share
				
				table_data_by_date[start_date] ||= {}
				table_data_by_date[start_date][p.long_name] ||= 0
				table_data_by_date[start_date][p.long_name] += share
			end
		end
		
		i=0
		s_min = table_data_by_date[start_date].min_by(&:last)[1]
		spread = table_data_by_date[start_date].max_by(&:last)[1] - s_min
		table_data_by_date[start_date].sort_by {|a| a.last}.reverse.each do |k,v|
			i+=1
			table_data_rankings[k] ||= {}
			table_data_rankings[k][start_date] = @graph_type == 1 ? i : (v - s_min)/spread * 100
		end
		
		start_date += 7
	end

	if @graph_type.zero?
		table_data = table_data_by_name
	else
		table_data = table_data_rankings
	end

	json_data = ""
	table_data.each do |name,a|
		
		# wish i could just convert a hash straight to a json string...
		# but the Date.UTC code would be in a string then...
		
		json_data += "," unless json_data.empty?
		json_data += "{\"name\": \"%s\", \"data\":" % name
		lr = ""
		a.each do |date,total|
			lr += "," if not lr.empty?
			lr += "[Date.UTC(%d,%d,%d), %d]" % [date.year,date.month-1,date.mday,total]
		end
		json_data += "[%s]}" % lr
	end

	$title = case @graph_type when 0 then "Revenue (USD)" when 1 then "Ranking" when 2 then "Spread %" end
	$min = @graph_type == 1 ? 1 : 0
	$reversed = @graph_type == 1 ? "true" : "false"
	$graph_output = json_data.html_safe
	render :layout => false
end

	def details
		render :layout => false
	end

end

class String
  def numeric?
    Float(self) != nil rescue false
  end
end
