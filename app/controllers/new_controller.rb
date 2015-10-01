class NewController < ApplicationController
  def index
    @seasons = Season.get_seasons(params[:season])
    @season = Season.get_selected_season(nil)
    teams = Team.where(season_id: @season.id)
    team = teams.where(slug: params[:team])
    @team = team.empty? ? teams.where(slug: 'friends').first : team.first

    if DateTime.now.utc > @season.start_date
      redirect_to controller: 'main'
      return
    end

    @movies = Movie.where(season_id: @season.id).order('release_date, id')
  end

  def create
    @season = Season.get_selected_season(nil)
    if DateTime.now.utc > @season.start_date
      render text: 'Too late!', status: 400
      return
    end
    if params[:name].empty?
      render text: "You didn't give a name!", status: 400
      return
    end

    shares = params[:shares].values.map { |s| Integer(s) }
    fail ArgumentError, 'At least one share is negative, or total is over 100' if shares.any? { |s| s < 0 } || shares.sum > 100
    p = Player.create(long_name: params[:name], short_name: params[:name], bonus1: params[:bonus1], bonus2: params[:bonus2], season_id: @season.id)

    t = Team.find(params[:team])
    t.players << p

    params[:shares].each do |k, v|
      Share.create(player_id: p.id, movie_id: k, num_shares: v)
    end

    flash[:thanks] = 1

    redis = Redis.new
    redis.flushall

    redirect_to action: 'index'
  end
end
