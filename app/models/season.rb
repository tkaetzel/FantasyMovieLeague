class Season < ActiveRecord::Base
  has_many :movies
  has_many :players
  has_many :urls

  def start_date
    movies.order(:release_date).first.release_date
  end

  def end_date
    movies.order('release_date DESC').first.release_date
  end

  def season_end_date
    end_date + 4.weeks
  end
end
