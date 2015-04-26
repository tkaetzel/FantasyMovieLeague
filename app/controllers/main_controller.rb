class MainController < ApplicationController
  def index
	season = get_season
	@seasons = [Season.order("id DESC"), season]
	
	case (params[:team] || "").downcase
	when 'friends'
		@players = Team.find(1).players.where(:season_id => season.id).includes(:shares)
	when 'work'
		@players = Team.find(2).players.where(:season_id => season.id).includes(:shares)
	when ''
		render "no_team"
		return
	else
		render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
		return
	end
	
	redis = Redis.new
	rankings_str = redis.get("%s:rankings:%s:%s" % [Rails.env, season.id, params[:team]])
	if !rankings_str.nil? then
		rankings = JSON.parse(rankings_str)
		@players.sort_by! {|p| rankings.index {|r| r["player"]["id"] == p.id}}
	end
  end
  
  def shares
	season = get_season
	@seasons = [Season.order("id DESC"), season]
	
	case (params[:team] || "").downcase
	when 'friends'
		@players = Team.find(1).players.where(:season_id => season.id).includes(:shares)
		@page_title = 'Shares: Friends'
	when 'work'
		@players = Team.find(2).players.where(:season_id => season.id).includes(:shares)
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
