class BstatsController < ApplicationController
	def index
		@hello = "hello"
	end
	
	def load_xml
	end
	
	def import_xml
    require "rexml/document"
    file=params[:document][:file]
    doc=REXML::Document.new(file.read)

		doc.elements.each("//SEASON") do |season|
			year = season.elements['YEAR'].text
			imp_year = Year.find_by_year( year )
			if not imp_year
				imp_year = Year.create(:year => year)
			end
			
			season.elements.each("//LEAGUE") do |league|
				league_name = league.elements['LEAGUE_NAME'].text
				imp_league = League.find_by_league_name( league_name )
				if not imp_league
					imp_league = League.create(:league_name => league_name)
				end
				
				league.elements.each("//DIVISION") do |division|
					division_name = division.elements['DIVISION_NAME'].text
					imp_division = Division.find_by_division_name( division_name )
					if not imp_division
						imp_division = Division.create(:division_name => division_name, :league_id => imp_league.id)
					end
					
					division.elements.each("//TEAM") do |team|
						team_city = team.elements['TEAM_CITY'].text
						team_name = team.elements['TEAM_NAME'].text
						imp_team = Team.find_by_team_name( team_name )
						if not imp_team
							imp_team = Team.create( :team_city = team_city, :team_name = team_name, :division_id => imp_division.id )
						end
						
						team.elements.each("//PLAYER") do |player|
							given_name = player.elements['GIVEN_NAME'].text
							surname = player.elements['SURNAME'].text
							postion = player.elements['POSITION'].text
							
							if not player.elements['AT_BATS'].nil?  # player has been at bat
								at_bats = player.elements['AT_BATS'].text.to_f
								runs = player.elements['RUNS'].text
								hits = player.elements['HITS'].text.to_f
								doubles = player.elements['DOUBLES'].text.to_f
								triples = player.elements['TRIPLES'].text.to_f
								home_runs = player.elements['HOME_RUNS'].text.to_f
								rbi = player.elements['RBI'].text
								steals = player.elements['STEALS'].text.to_f
								sacrifice_hits = player.elements['SACRIFICE_HITS'].text
								sacrifice_flies = player.elements['SACRIFICE_FLIES'].text.to_f
								walks = player.elements['WALKS'].text.to_f
								struck_out = player.elements['STRUCK_OUT'].text
								hit_by_pitch = player.elements['HIT_BY_PITCH'].text.to_f
		
								# if got a hit, calculate AVG
								if hits > 0
									avg = hits / at_bats
								else
									avg = 0
								end
								puts format("#{avg} to AVG %.3f\n",avg)
								
								# calculate OPS - On-base plus slugging (formular from wikipedia.com)
								#
								#       at_bats * ( hits + walks + hit_by_pitch) + total_bases * (at_bats + walks + sacrifice_flies + hit_by_pitch)
								# OPS = -------------------
								#       at_bats * ( at_bats + walks + sacrifice_flies + hit_by_pitch)
								#
								total_bases = (doubles * 2) + (triples * 3) + (home_runs * 4)
								singles = hits - total_bases
								total_bases = total_bases + singles
								
								top_equ = at_bats * ( hits + walks + hit_by_pitch) + total_bases * (at_bats + walks + sacrifice_flies + hit_by_pitch)
								bottom_equ = at_bats * ( at_bats + walks + sacrifice_flies + hit_by_pitch)
								ops = top_equ / bottom_equ
								puts format("#{ops} to OPS %.3f\n",ops)
								
								puts "HOME RUNS: #{home_runs.to_i}"
		
								imp_player = Player.find(:all, :conditions => ["given_name = :given_name and surname = :surname and position = :position"])
								if not imp_player
									imp_player = Player.create(:given_name => given_name, :surname => surname, :position => position)
								end
		
							end

						end
					end
				end
			end
		end
	end			
end