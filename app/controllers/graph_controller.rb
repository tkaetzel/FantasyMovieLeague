class GraphController < ApplicationController
  def get_graph
	render :layout => false
	
	$title = ""
	$min = 0
	$reversed = ""
	$graph_output = ""
	
	case (params[:type] || "").downcase
	when 'rank'
		@rank = true
	when 'weekly'
		@rank = false
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
		Hash[(scores.sort_by &:last).reverse].each do |key,gross| 
			table_data[key] ||= {}
			table_data[key][start_date] = @rank ? i : gross
			i+=1
		end
		
		start_date += 7
	end
	
	json_data = ""
	
	table_data.each do |name,a|
		json_data += "," if not json_data.empty?
		json_data += "{\"name\": \"%s\", \"data\":" % name
		lr = ""
		a.each do |date,total|
			lr += "," if not lr.empty?
			lr += "[Date.UTC(%d,%d,%d), %d]" % [date.year,date.month-1,date.mday,total]
		end
		json_data += "[%s]}" % lr
	end
	
	$title = @rank ? "Ranking" : "Revenue (USD)"
	$min = @rank ? 1 : 0
	$reversed = @rank ? "true" : "false"
	$graph_output = json_data.html_safe
	
end
end
