class Share < ActiveRecord::Base
	belongs_to :shares
	belongs_to :movies
end