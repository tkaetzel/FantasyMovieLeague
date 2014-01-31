class NewController < ApplicationController
	def index
		if $NOW > $START_DATE then
			redirect_to controller:"main"
			return
		end
		$movies = Movie.order("id")
	end
end
