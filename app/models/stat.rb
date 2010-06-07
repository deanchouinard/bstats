class Stat < ActiveRecord::Base
	belongs_to :year
	belongs_to :player
	belongs_to :team
	
end
