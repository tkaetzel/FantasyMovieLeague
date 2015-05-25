class Season < ActiveRecord::Base
  has_many :movies
  has_many :players
  has_many :urls

  def self.get_seasons(id)
    seasons = Season.order('id DESC')
    season = !id.nil? ? seasons.find_by(slug: id) : seasons.first
    fail 'Season not found' if season.nil?
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

  def get_movies_with_earnings(id)
    if id.nil?
      return movies.includes(:earnings)
    else
      return movies.includes(:earnings).where(id: id.to_i)
    end
  end

  def get_movie_data(players)
    ms = movies.includes(:shares, :earnings)
    best_movies, worst_movies = get_best_and_worst_movies
    rows = []

    ms.each do |m|
      this_movie_gross = m.earnings.empty? ? 0 : m.earnings.max_by(&:created_at).gross
      total_shares = m.shares.where(player_id: players).sum(:num_shares)
      this_movie_value = total_shares.zero? ? 0 : this_movie_gross / total_shares

      this_movie = {
        'id' => m.id,
        'movie' => m.name,
        'releasedate' => m.release_date.strftime('%F'),
        'rating' => { 'rating' => m.rotten_tomatoes_rating, 'class' => '' },
        'total' => { 'earning' => this_movie_gross, 'shares' => total_shares },
        'value' => { 'earning' => this_movie_value }
      }

      if best_movies.include?(m.id) && !m.rotten_tomatoes_rating.nil?
        this_movie['rating']['class'] = 'darkgreen'
      elsif worst_movies.include?(m.id) && !m.rotten_tomatoes_rating.nil?
        this_movie['rating']['class'] = 'darkred'
      end

      players.each do |p|
        s = p.shares.find { |a| a.movie_id == m.id }
        earning = 0
        css_class = ''

        if !this_movie_gross.nil? && !this_movie_gross.zero?
          earning = s.nil? ? 0 : s.num_shares.to_f / total_shares * this_movie_gross
        end

        if best_movies.include?(m.id) && p['bonus1'] == m.id
          earning += 10_000_000
          css_class = 'darkgreen'
        elsif p['bonus1'] == m.id
          css_class = 'green'
        end

        if worst_movies.include?(m.id) && p['bonus2'] == m.id
          earning += 10_000_000
          css_class = 'darkred'
        elsif p['bonus2'] == m.id
          css_class = 'red'
        end

        this_movie[p.short_name] = { 'earning' => earning, 'shares' => s.num_shares, 'class' => css_class }
      end
      rows.push this_movie
    end
    rows
  end

  def get_rankings_data(players)
    ms = movies.includes(:shares, :earnings)
    best_movies, worst_movies = get_best_and_worst_movies
    rows = []

    players.each do |p|
      this_player = {
        'rank' => 0,
        'player' => { 'id' => p.id, 'long_name' => p.long_name, 'short_name' => p.short_name },
        'pct_in_use' => 0,
        'revenue' => 0
      }

      ms.each do |m|
        this_movie_gross = m.earnings.empty? ? 0 : m.earnings.max_by(&:created_at).gross
        total_shares = m.shares.where(player_id: players).sum(:num_shares)
        s = p.shares.find { |a| a.movie_id == m.id }

        if !this_movie_gross.nil? && !this_movie_gross.zero?
          this_player['revenue'] += s.nil? ? 0 : s.num_shares.to_f / total_shares * this_movie_gross
          this_player['pct_in_use'] += s.num_shares if (m.release_date + 1.days) < DateTime.now
        end
      end

      if best_movies.include? p[:bonus1]
        this_player['revenue'] += 10_000_000
        this_player['player']['long_name'] += '&sup1;'
      end
      if worst_movies.include? p[:bonus2]
        this_player['revenue'] += 10_000_000
        this_player['player']['long_name'] += '&sup2;'
      end

      rows.push this_player
    end

    rank = 1
    rows.sort_by! { |a| a['revenue'] }.reverse!
    rows.each do |a|
      a['rank'] = rank
      rank += 1
    end
    rows
  end

  def get_shares_data(players)
    ms = movies.includes(:shares)
    rows = []
    ms.each do |m|
      this_movie = {}
      players.each do |p|
        s = p.shares.find { |a| a.movie_id == m.id }
        share = s.nil? ? 0 : s.num_shares
        css_class = p['bonus1'] == m.id ? 'green' : p['bonus2'] == m.id ? 'red' : ''
        this_movie[p.short_name] = { 'shares' => share, 'class' => css_class }
      end
      this_movie['movie'] = m.name
      this_movie['total'] = m.shares.where(player_id: players).sum(:num_shares)
      this_movie['releasedate'] = m.release_date.strftime('%F')
      rows.push this_movie
    end
    rows
  end

  def get_graph_data(players)
    ms = movies.includes(:shares, :earnings)
    best_movies, worst_movies = get_best_and_worst_movies

    _start_date = start_date
    _end_date = DateTime.now.utc < end_date ? DateTime.now.utc : end_date
    name = {}
    date = {}
    rankings = {}
    spreads = {}

    while _start_date <= _end_date
      _start_date += 1 until _start_date.wday == 0
      timestamp = _start_date.to_i * 1000
      ms.each do |m|
        earning = m.earnings.reverse.find { |e| e.created_at < (_start_date + 1.days) }
        gross = earning.nil? ? 0 : earning.gross
        total_shares = m.shares.where(player_id: players).sum(:num_shares)

        players.each do |p|
          s = p.shares.find { |a| a.movie_id == m.id }
          share = s.nil? ? 0 : s.num_shares.to_f / total_shares * gross

          if m == ms.first
            share += 10_000_000 if best_movies.include? p[:bonus1]
            share += 10_000_000 if worst_movies.include? p[:bonus2]
          end

          name[p.long_name] ||= {}
          name[p.long_name][timestamp] ||= 0
          name[p.long_name][timestamp] += share

          date[timestamp] ||= {}
          date[timestamp][p.long_name] ||= 0
          date[timestamp][p.long_name] += share
        end
      end

      i = 0
      s_min = date[timestamp].min_by(&:last)[1]
      spread = date[timestamp].max_by(&:last)[1] - s_min
      date[timestamp].sort_by(&:last).reverse_each do |k, v|
        i += 1
        rankings[k] ||= {}
        spreads[k] ||= {}
        rankings[k][timestamp] = i
        spreads[k][timestamp] = (v - s_min) / spread * 100
      end

      _start_date += 7.days
    end

    rows = [
      name.map { |a| [a.to_a.first, a.to_a.last.to_a] },
      rankings.map { |a| [a.to_a.first, a.to_a.last.to_a] },
      spreads.map { |a| [a.to_a.first, a.to_a.last.to_a] }]
    rows
  end

  private

  def get_best_and_worst_movies
    return [[], []] unless movies.any? { |m| !m.rotten_tomatoes_rating.nil? }
    best_rating = movies.select { |a| !a[:rotten_tomatoes_rating].nil? }.map { |a| a[:rotten_tomatoes_rating] }.max
    best_movies = movies.select { |a| a[:rotten_tomatoes_rating] == best_rating }.map { |a| a[:id] }

    worst_rating = movies.select { |a| !a[:rotten_tomatoes_rating].nil? }.map { |a| a[:rotten_tomatoes_rating] }.min
    worst_movies = movies.select { |a| a[:rotten_tomatoes_rating] == worst_rating }.map { |a| a[:id] }

    [best_movies, worst_movies]
  end
end
