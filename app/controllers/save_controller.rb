class SaveController < ApplicationController
	def index
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
		
		p = Player.create long_name: params[:name], short_name: params[:name]
		
		params[:shares].each do |k,v|
			Share.create player_id: p.id, movie_id: k, num_shares: v
		end
		
		flash[:thanks] = 1
		redirect_to controller:"new"
	end
end