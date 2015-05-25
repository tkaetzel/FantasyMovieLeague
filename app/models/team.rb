class Team < ActiveRecord::Base
  has_and_belongs_to_many :players

  def self.get_players_by_season(team_slug, season_id, abc_order)
    result = abc_order ?
      get_players_by_season_abc_order(team_slug, season_id) :
      get_players_by_season_no_order(team_slug, season_id)
    fail Exceptions::SeasonNotFoundError, 'Season not found' if result.nil?
    result
  end

  private

  def self.get_players_by_season_no_order(team_slug, season_id)
    case team_slug.downcase
    when 'friends'
      return Team.find(1).players.where(season_id: season_id).includes(:shares)
    when 'work'
      return Team.find(2).players.where(season_id: season_id).includes(:shares)
    else
      fail(Exceptions::TeamNotFoundError, 'Team not found')
    end
  end

  def self.get_players_by_season_abc_order(team_slug, season_id)
    case team_slug.downcase
    when 'friends'
      return Team.find(1).players.order(:short_name).where(season_id: season_id).includes(:shares)
    when 'work'
      return Team.find(2).players.order(:short_name).where(season_id: season_id).includes(:shares)
    else
      fail(Exceptions::TeamNotFoundError, 'Team not found')
    end
  end
end
