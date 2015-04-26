class Player < ActiveRecord::Base
	has_many :shares
	has_many :movies, through: :shares
	belongs_to :season
end