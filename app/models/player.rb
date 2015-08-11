class Player < ActiveRecord::Base
  has_many :shares
  has_many :movies, through: :shares
  has_and_belongs_to_many :teams
end
