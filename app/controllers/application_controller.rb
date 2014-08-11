class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  $START_DATE = DateTime.new(2014,11,6,0,0,0,'-4')
  $NOW = DateTime.now
  $END_DATE  = DateTime.new(2014,12,25,0,0,0,"-4")
  $SEASON_END_DATE = $END_DATE + 4.weeks
  
  def index
    if $NOW < $START_DATE then
		redirect_to controller:"new", status: :found
		return
	end
	
    @COL_HEADER = "'%s', "
	@COL_MODEL = "{name:'%s', align:'right', index:'%s', width:45, formatter: formatMoney},"
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
  end
  
  def shares
    if $NOW < $START_DATE then
		redirect_to controller:"new", status: :found
		return
	end
	
    @COL_HEADER = "'%s', "
	@COL_MODEL = "{name:'%s', align:'right', index:'%s', width:35, sorttype:'int'},\r\n"
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
    
  helper_method :is_active, :to_currency
  
  def is_active(a)
	if request.env['PATH_INFO'] == a
		return "class=\"is_active\"".html_safe
	else
		return ""
	end
  end
end