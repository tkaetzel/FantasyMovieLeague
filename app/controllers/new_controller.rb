class NewController < ApplicationController
	def index
		if $NOW > $START_DATE then
			redirect_to controller:"main"
			return
		end
		@movies = Movie.order("id")
	end
	
	def create
		raise "Not ready yet!"
		if $NOW > $START_DATE then
			render text: "Too late!", status: 400
			return
		end
		if params[:name].empty? then
			render text: "You didn't give a name!", status: 400
			return
		end

		shares = params[:shares].values.map {|s| Integer(s)}
		raise ArgumentError, 'At least one share is negative, or total is over 100' if shares.any? {|s| s < 0} or shares.sum > 100
		p = Player.create long_name: params[:name], short_name: params[:name], bonus1: params[:bonus1], bonus2: params[:bonus2]
		
		params[:shares].each do |k,v|
			Share.create player_id: p.id, movie_id: k, num_shares: v
		end

		flash[:thanks] = 1
		redirect_to action:"index"
	end
end
