require 'rss'

class FeedController < ApplicationController
  def index
    players = Player.order('id DESC')

    rss = RSS::Maker.make('atom') do |maker|
      maker.channel.author = 'Nick Rogers'
      maker.channel.updated = players.first.created_at.to_s
      maker.channel.about = 'http://movie.nickroge.rs/'
      maker.channel.title = 'Movie Contest'

      players.each do |p|
        maker.items.new_item do |item|
          item.id = 'http://movie.nickroge.rs/' + p.id.to_s
          item.link = 'http://movie.nickroge.rs/'
          item.title = format('New movie draft submission by %s!', p.long_name)
          item.updated = p.created_at.to_s
        end
      end
    end

    render text: rss, layout: false, content_type: 'application/atom+xml'
  end
end
