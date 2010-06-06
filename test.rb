require 'rexml/document'
include REXML
doc = Document.new(File.new("bstats.xml"))
# root = doc.root
# puts root.elements[1].text
# doc.elements.each("//LEAGUE/LEAGUE_NAME") {|e| puts e.text}

doc.elements.each("//SEASON") do |season|
	puts season.elements['YEAR'].text
	
	season.elements.each("//LEAGUE") do |league|
		puts league.elements['LEAGUE_NAME'].text
		
		league.elements.each("//DIVISION") do |division|
			puts division.elements['DIVISION_NAME'].text
			
			division.elements.each("//TEAM") do |team|
				puts team.elements['TEAM_CITY'].text
				puts team.elements['TEAM_NAME'].text
				
				team.elements.each("//PLAYER") do |player|
					puts player.elements['GIVEN_NAME'].text
					puts player.elements['SURNAME'].text
					puts player.elements['POSITION'].text
					
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


					end
					
				end
					
				
			end
		end
		
	end
	
end