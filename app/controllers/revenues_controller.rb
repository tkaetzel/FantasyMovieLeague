require 'net/http'

class RevenuesController < ApplicationController
  def index
    data = []
    queries = ''
    season = Season.get_selected_season(nil)
    movies = Movie.where(season_id: season.id)

    Earning.where('DATE(created_at) = ?', Time.now.utc.strftime('%Y-%m-%d')).destroy_all # to prevent duplicates

    urls = season.urls.pluck(:url)
    if Time.now.utc > season.season_end_date
      render layout: false, content_type: 'text/plain'
      return
    end

    tries = 0

    urls.each do |url|
      uri = URI(url)
      html = Net::HTTP.get(uri)
      doc = Nokogiri::HTML(html)
      context = doc.xpath "//form[@name='MojoDropDown1']/ancestor::table[2]/tr"
      if context.nil? || context.empty?
        tries += 1
        sleep 4
        redo if tries < 5
      end

      for i in 1..context.length - 1 do
        row = context[i]
        begin
          name = row.xpath('td[3]')[0].content
          movie = movies.select { |m| m.name == name || m.mapped_name == name }
          next if movie.empty?

          gross = row.xpath('td[5]')[0].content.gsub(/\$|,/, '').to_i
          movie.first.earnings += [Earning.new(gross: gross)]
          queries += format("%s: %d\r\n", name, gross)
        rescue
          next
        end
      end
    end
    queries += "\r\n"
    # now get the rotten tomatoes data
    rt = movies.where(format("release_date <= date('%s','3 days')", DateTime.now.strftime('%F')))
    rt.each do |m|
      next if m.rotten_tomatoes_id.nil?
      uri = URI(format('http://api.rottentomatoes.com/api/public/v1.0/movies/%d.json?apikey=%s', m.rotten_tomatoes_id, SECRETS['rotten-tomatoes-api-key']))
      data = JSON.parse(Net::HTTP.get(uri))
      rating = Integer(data['ratings']['critics_score'])
      if rating > 0
        m.rotten_tomatoes_rating = rating
        queries += format("%s: %d%%\r\n", m.name, rating)
        m.save
      end
      sleep 0.5
    end

    # flush the cache
    redis = Redis.new
    redis.flushall

    # and load each team page to reset the orders
    teams = season.teams.pluck(:slug)
    teams.each do |t|
      Net::HTTP.get(URI('http://movie.nickroge.rs/api/rankings/' + t))
    end

    output = <<OUTPUT
#{queries}
OUTPUT
    render layout: false, text: output, content_type: 'text/plain'
  end
end
