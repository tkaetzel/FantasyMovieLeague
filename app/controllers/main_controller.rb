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
		render "no_team"
		return
	else
		render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
		return
	end
	
	redis = Redis.new
	rankings_str = redis.get("%s:rankings:%s" % [Rails.env, params[:team]])
	
	if !rankings_str.nil? then
		rankings = JSON.parse(rankings_str)
		@players.sort_by! {|p| rankings.index {|r| r["player"]["id"] == p.id}}
	end
  end
  
  def shares
    if @@NOW < @@START_DATE && params[:skip].nil? then
		redirect_to controller:"new", status: :found
		return
	end

	case (params[:team] || "").downcase
	when 'friends'
		@players = Team.find(1).players.includes(:shares)
		@page_title = 'Shares: Friends'
	when 'work'
		@players = Team.find(2).players.includes(:shares)
		@page_title = 'Shares: Work'
	when ''
		render "no_team"
		return
	else
		render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
		return
	end
	
  end
end
