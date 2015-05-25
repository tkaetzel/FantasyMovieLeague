class MainController < ApplicationController
  def index
    return unless main_start(false)

    redis = Redis.new
    rankings_str = redis.get('%s:rankings:%s:%s' % [Rails.env, @seasons[:selected_season].id, params[:team]])
    unless rankings_str.nil?
      rankings = JSON.parse(rankings_str)
      @players = @players.sort_by { |p| rankings.index { |r| r['player']['id'] == p.id } }
    end
  end

  def shares
    main_start(true)
  end

  private

  def main_start(abc_order)
    begin
      @seasons = Season.get_seasons(params[:season])
    rescue StandardError
      render file: "#{Rails.root}/public/404", layout: false, status: :not_found
      return false
    end

    if params[:team].nil?
      render 'no_team'
      return false
    end

    begin
      @players = Team.get_players_by_season(params[:team], @seasons[:selected_season], abc_order)
    rescue StandardError
      render file: "#{Rails.root}/public/404", layout: false, status: :not_found
      return false
    end

    true
  end
end
