class Share < ActiveRecord::Base
  belongs_to :player
  belongs_to :movie
end
