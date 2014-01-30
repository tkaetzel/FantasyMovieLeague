class SaveController < ApplicationController
	def index
		if params[:name].empty? then
			render text: "You didn't give a name!", status: 400
			return
		end
		
		p = Player.create long_name: params[:name], short_name: params[:name]
		
		params[:shares].each do |k,v|
			Share.create player_id: p.id, movie_id: k, num_shares: v
		end
		
	end
end
