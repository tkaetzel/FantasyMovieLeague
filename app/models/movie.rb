class Movie < ActiveRecord::Base
  has_many :shares
  has_many :earnings
  has_many :players, through: :shares
  belongs_to :seasons

  def get_graph_data
    return nil if earnings.count.zero?
    ret = {
      'name' => name,
      'data' => [[(release_date - 1.day).strftime('%s').to_i * 1000, 0]]
    }
    last_earning = earnings.order(:created_at).last
    earnings.order(:created_at).each do |e|
      if e.created_at.wday == 0 || e == last_earning
        ret['data'].push([e.created_at.strftime('%s').to_i * 1000, e.gross])
      end
    end
    ret
  end
end
