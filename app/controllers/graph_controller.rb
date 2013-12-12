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
	
	db = connect
	results = db.query("CALL GetPercentages(#{@team})")
	
	results.each do |row|
		percentages[row["name"]] = row.except("name")
	end
	db.close
	
	start_date = Date.new(2013,11,3)
	now = DateTime.now
	stop_date = Date.new(2014,1,22)
	data = {}
	
	stop_date = now if now < stop_date
	table_data = {}
	
	while start_date < stop_date
		db = connect
		query = "CALL GetGross('%s')" % start_date.strftime('%Y-%m-%d')
		grs = db.query(query)
		
		grosses = {}
		scores = {}
		
		grs.each do |row|
			grosses[row["name"]] = row["Gross"]
		end

		pct = percentages.clone
		pct.each do |movie,p|
			next if grosses[movie].nil?

			p.each do |key, _|
				scores[key] ||= 0
				scores[key] += p[key] * grosses[movie]
			end
		end
		db.close

		i=1
		s_min = scores.min_by(&:last)[1]
		spread = scores.max_by(&:last)[1] - s_min
		Hash[(scores.sort_by &:last).reverse].each do |key,gross| 
			table_data[key] ||= {}
			case @graph_type
			when 0
				table_data[key][start_date] = gross
			when 1
				table_data[key][start_date] = i
			when 2
				table_data[key][start_date] = (gross - s_min)/spread * 100
			end
			i+=1
		end
		
		start_date += 7
	end
	
	json_data = ""
	
	table_data.each do |name,a|
		
		# wish i could just convert a hash straight to a json string...
		# but the Date.UTC code would be in a string then...
		
		json_data += "," if not json_data.empty?
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
		db = connect
		$movie = params[:movie] || ""
		$movie = URI.unescape($movie)
		if !$movie.empty? then
			query = "SELECT m.name AS 'Movie', e.gross AS 'Gross', YEAR(e.on_date) AS 'Year', MONTH(e.on_date) AS 'Month', DAY(e.on_date) AS 'Day' FROM `earnings` e
		INNER JOIN `movies` m ON m.id = e.movie_id
		WHERE m.name LIKE \"#{params[:movie]}\" ORDER BY e.on_date ASC"
		else
			query = "SELECT m.name AS 'Movie', e.gross AS 'Gross', YEAR(e.on_date) AS 'Year', MONTH(e.on_date) AS 'Month', DAY(e.on_date) AS 'Day' FROM `earnings` e
		INNER JOIN `movies` m ON m.id = e.movie_id
		ORDER BY m.name, e.on_date ASC"
		end
	
		result = db.query(query)
		$movie = ""
		data = []
		to_add = {}
		
		if result.count.zero? then
			render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
			return			
		end
		
		result.each do |a|
			if a["Movie"] != $movie then
				if !to_add.empty? then
					data.push to_add
				end
				to_add = {}
				to_add["name"] = a["Movie"]
				to_add["data"] ||= []
				to_add["data"].push "[Date.UTC(%d,%d,%d), %d]" % [a["Year"], a["Month"]-1, a["Day"]-1, 0]
				
				$movie = a["Movie"]
			end
			
			to_add["data"].push "[Date.UTC(%d,%d,%d), %d]" % [a["Year"], a["Month"]-1, a["Day"], a["Gross"]]
		end
		
		if !to_add.empty? then
			data.push to_add
		end
		
		if (params[:movie] || "").empty? then
			$movie = "All Movies"
		end
	
		$json_data = ""
		data.each do |ta|
			if !$json_data.empty? then
				$json_data += ",\r\n"
			end
			$json_data += "{'name':'%s', 'data':%s}" % [ta["name"].gsub(/'/,"\\\\'"), JSON.generate(ta["data"]).gsub(/"/,"")]
		end
		
		$movie = $movie.html_safe
		$json_data = $json_data.html_safe
		render :layout => false
	end
end

class String
  def numeric?
    Float(self) != nil rescue false
  end
end
