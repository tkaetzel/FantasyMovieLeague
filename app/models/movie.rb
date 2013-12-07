class Movie
	@name = ""
	@gross = 0
	@theaters = 0
	@open = nil
	
	def name
		return @rank
	end
	
	def name=(v)
		@rank = v
	end
	
	def gross
		return @gross
	end
	
	def gross=(v)
		@gross = v.gsub(/\$|\,/,"").to_i
	end	
	
	def theaters
		return @theaters
	end
	
	def theaters=(v)
		@theaters = v.gsub(/,/,"").to_i
	end
	
	def open
		return @open
	end
	
	def open=(v)
		ap v
		@open = Date.parse(v)
	end
	
end