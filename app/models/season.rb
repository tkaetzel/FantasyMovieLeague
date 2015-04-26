class Season < ActiveRecord::Base
	has_many :movies
	has_many :players
end