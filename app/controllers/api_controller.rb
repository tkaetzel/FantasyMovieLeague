class ApiController < ApplicationController
  def movie_data
    get_formatted_data('movie_data')
  end

  def rankings
    get_formatted_data('rankings')
  end

  def shares
    get_formatted_data('shares')
  end

  def graph_data
    season = Season.get_selected_season(params[:season])
    results = []

    movies = season.get_movies_with_earnings(params[:id])

    movies.each do |m|
      d = m.get_graph_data
      results.push(d) unless d.nil?
    end

    render json: results
  end

  def graph_totals
    results = []
    table_data = get_graph_data.first
    table_data.each do |k, v|
      data = v.to_a.map { |a| [a.first, a.last.round] }
      d = { name: k, data: data }
      results.push d
    end

    render json: results
  end

  def graph_rankings
    results = []
    table_data = get_graph_data.second
    table_data.each do |k, v|
      d = { name: k, data: v.to_a }
      results.push d
    end

    render json: results
  end

  def graph_spread
    results = []
    table_data = get_graph_data.last
    table_data.each do |k, v|
      data = v.to_a.map { |a| [a.first, a.last.round] }
      d = { name: k, data: data }
      results.push d
    end

    render json: results
  end

  private

  def get_formatted_data(type)
    season = Season.get_selected_season(params[:season])
    redis = Redis.new

    rows_json = redis.get(format('%s:%s:%s:%s', Rails.env, type, season.id, params[:id]))

    if rows_json.nil?
      begin
        players = Team.get_players_by_season(params[:id], season.id, type == 'shares')
      rescue StandardError => e
        render status: :not_found, text: e
        return
      end

      case type
      when 'movie_data'
        rows = season.get_movie_data(players)
      when 'rankings'
        rows = season.get_rankings_data(players)
      when 'shares'
        rows = season.get_shares_data(players)
      end

      redis.set(format('%s:%s:%s:%s', Rails.env, type, season.id, params[:id]), rows.to_json)
    else
      rows = JSON.parse(rows_json)
    end

    results = {
      'total' => 1,
      'page' => 1,
      'records' => rows.length,
      'rows' => rows
    }

    if !params[:sidx].nil? && !params[:sord].nil?
      rows.sort_by! { |a| do_sort(a[params[:sidx]]) }
      rows.reverse! if params[:sord] == 'desc'
    end

    render json: results
  end

  def get_graph_data
    season = Season.get_selected_season(params[:season])
    redis = Redis.new

    rows_json = redis.get(format('%s:graph:%s:%s', Rails.env, season.id, params[:id]))

    if rows_json.nil?
      begin
        players = Team.get_players_by_season(params[:id], season.id)
      rescue StandardError => e
        render status: :not_found, text: e
        return
      end

      rows = season.get_graph_data(players)
      redis.set(format('%s:graph:%s:%s', Rails.env, season.id, params[:id]), rows.to_json)
    else
      rows = JSON.parse(rows_json)
    end
    rows
  end

  def do_sort(a)
    return a unless a.is_a?(Hash)
    return a['rating'] if !a['rating'].nil? && a['rating'] > 0
    return a['earning'] if !a['earning'].nil? && a['earning'] > 0
    return a['shares'] if !a['shares'].nil? && a['shares'] > 0
    return a['long_name'] unless a['long_name'].nil?
    0
  end
end
