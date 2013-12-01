class Ranking
	@rank = 0
	@player = ""
	@revenue = ""
	@pct_in_use = 0
	
	def rank
		return @rank
	end
	
	def rank=(v)
		@rank = v
	end
	
	def player
		return @player
	end
	
	def player=(v)
		@player = v
	end	
	
	def revenue
		return @revenue
	end
	
	def revenue=(v)
		@revenue = ActionController::Base.helpers.number_to_currency(v, precision:0)
	end
	
	def pct_in_use
		return @pct_in_use
	end
	
	def pct_in_use=(v)
		@pct_in_use = v
	end
	
end