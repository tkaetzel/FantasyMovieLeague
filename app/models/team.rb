class Team < ActiveRecord::Base
  has_and_belongs_to_many :players

  def self.get_players_by_season(team_slug, season_id)
    case team_slug.downcase
    when 'friends'
      return Team.find(1).players.where(season_id: season_id).includes(:shares)
    when 'work'
      return Team.find(2).players.where(season_id: season_id).includes(:shares)
    else
      fail 'Team not found'
    end
  end
end
