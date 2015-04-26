class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  @@START_DATE = DateTime.new(2015,5,1,0,0,0,'-4')
  @@NOW = DateTime.now
  @@END_DATE  = DateTime.new(2015,9,4,0,0,0,'-4')
  @@SEASON_END_DATE = @@END_DATE + 4.weeks
      
  helper_method :is_active
  
  def is_active(a)
	return "class=\"is_active\"".html_safe if request.env['PATH_INFO'].start_with? a
	return ""
  end
  
  def get_season
	season = nil
	if !params[:season].nil? then
		season = Season.where(:slug => params[:season]).first
		if season.nil? then
			render :status => :not_found, :text => ''
			return
		end
	else
		season = Season.last
	end
	return season
  end
  
end