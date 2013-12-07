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
end
