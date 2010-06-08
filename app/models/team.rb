class Team < ActiveRecord::Base
	has_many :stats
	belongs_to :division
	
end
