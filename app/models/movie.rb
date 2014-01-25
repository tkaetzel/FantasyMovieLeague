class Movie < ActiveRecord::Base
	has_many :shares
	has_many :earnings
	has_many :players, through: :shares
end