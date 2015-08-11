class Season < ActiveRecord::Base
  has_many :movies
  has_many :teams
  has_many :urls

  def self.get_seasons(id)
    seasons = Season.order('id DESC')
    season = !id.nil? ? seasons.find_by(slug: id) : seasons.first
    fail(Exceptions::SeasonNotFoundError, 'Season not found') if season.nil?
    {
      seasons: seasons,
      selected_season: season
    }
  end

  def self.get_selected_season(id)
    get_seasons(id)[:selected_season]
  end

  def start_date
    movies.order(:release_date).first.release_date
  end

  def end_date
    movies.order('release_date DESC').first.release_date
  end

  def season_end_date
    end_date + 4.weeks
  end

  def get_team(team_slug)
    team = teams.where(slug: team_slug)
    fail 'Team not found' if team.empty?
    team.first
  end

  def get_movies_with_earnings(id)
    if id.nil?
      return movies.includes(:earnings)
    else
      return movies.includes(:earnings).where(id: id.to_i)
    end
  end

  def get_best_and_worst_movies
    return [[], []] unless movies.any? { |m| !m.rotten_tomatoes_rating.nil? }
    best_rating = movies.select { |a| !a[:rotten_tomatoes_rating].nil? }.map { |a| a[:rotten_tomatoes_rating] }.max
    best_movies = movies.select { |a| a[:rotten_tomatoes_rating] == best_rating }.map { |a| a[:id] }

    worst_rating = movies.select { |a| !a[:rotten_tomatoes_rating].nil? }.map { |a| a[:rotten_tomatoes_rating] }.min
    worst_movies = movies.select { |a| a[:rotten_tomatoes_rating] == worst_rating }.map { |a| a[:id] }

    [best_movies, worst_movies]
  end
end
