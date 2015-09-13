class MainController < ApplicationController
  def index
    return unless main_start(false)

    redis = Redis.new
    rankings_str = redis.get(format('%s:rankings:%s:%s', Rails.env, @seasons[:selected_season].id, params[:team]))
    return if rankings_str.nil?

    rankings = JSON.parse(rankings_str)
    @players = @players.sort_by { |p| rankings.index { |r| r['player']['id'] == p.id } }
  end

  def shares
    main_start(true)
  end

  private

  def main_start(abc_order)
    begin
      @seasons = Season.get_seasons(params[:season])
    rescue Exceptions::SeasonNotFound
      render file: "#{Rails.root}/public/404", layout: false, status: :not_found
      return false
    end

    if @seasons[:selected_season].start_date > DateTime.now && params[:skip].nil?
      redirect_to controller: 'new'
      return false
    end

    if params[:team].nil?
      render 'no_team'
      return false
    end

    begin
      team = @seasons[:selected_season].get_team(params[:team])
      @players = team.get_players(abc_order)
    rescue Exceptions::TeamNotFound
      render file: "#{Rails.root}/public/404", layout: false, status: :not_found
      return false
    end

    true
  end
end
