class Share < ActiveRecord::Base
	belongs_to :shares, :movies
end