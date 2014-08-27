class MainController < ApplicationController
  def index
    if @@NOW < @@START_DATE && params[:skip].nil? then
		redirect_to controller:"new", status: :found
		return
	end

	case (params[:team] || "").downcase
	when 'friends'
		@players = Team.find(1).players.includes(:shares)
	when 'work'
		@players = Team.find(2).players.includes(:shares)
	when ''
		@players = Player.all.includes(:shares)
	else
		render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
		return
	end
	
	redis = Redis.new
	@col_names = redis.get("rankings-colnames:%s" % params[:team])
  end
  
  def shares
    if @@NOW < @@START_DATE && params[:skip].nil? then
		redirect_to controller:"new", status: :found
		return
	end

	case (params[:team] || "").downcase
	when 'friends'
		@players = Team.find(1).players.order(:short_name)
	when 'work'
		@players = Team.find(2).players.order(:short_name)
	when ''
		@players = Player.all.order(:short_name)
	else
		render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
		return
	end
  end
end
