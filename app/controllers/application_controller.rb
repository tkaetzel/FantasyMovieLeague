class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :active?

  def active?(a)
    return "class=\"is_active\"".html_safe if request.env['PATH_INFO'].start_with? a
    ''
  end

  def get_season
    season = nil
    if !params[:season].nil?
      season = Season.where(slug: params[:season]).first
      if season.nil?
        render status: :not_found, text: ''
        return
      end
    else
      season = Season.last
    end
    season
  end
end
