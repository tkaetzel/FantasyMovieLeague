
class RevenuesController < ApplicationController
  def index
	db = connect
	curl = CURL.new
	
	render :layout => false
  end
end
