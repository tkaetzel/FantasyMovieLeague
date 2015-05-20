class Season < ActiveRecord::Base
	has_many :movies
	has_many :players
	has_many :urls
	
	def start_date
		return self.movies.order(:release_date).first.release_date
	end
	
	def end_date
		return self.movies.order('release_date DESC').first.release_date
	end
	
	def season_end_date
		return end_date() + 4.weeks
	end
	
end