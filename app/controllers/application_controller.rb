class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  @@START_DATE = DateTime.new(2014,4,4,0,0,0,'-4')
  @@NOW = DateTime.now
  @@END_DATE  = DateTime.new(2014,8,8,0,0,0,"-4")
  @@SEASON_END_DATE = @@END_DATE + 4.weeks
      
  helper_method :is_active
  
  def is_active(a)
	return "class=\"is_active\"".html_safe if request.env['PATH_INFO'] == a
	return ""
  end
end