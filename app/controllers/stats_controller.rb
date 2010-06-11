class StatsController < ApplicationController

  require "rexml/document"
  include REXML

  # GET /stats
  # GET /stats.xml
  def index
    @stats = Stat.find(:all, :order => "avg DESC", :limit => 25)
    @avg_url = "sort_table"
    @stat = "avg"
    @order = "asc"
        
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stats }
    end
  end

  # GET /stats/1
  # GET /stats/1.xml
  def show
    @stat = Stat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stat }
    end
  end

  # GET /stats/new
  # GET /stats/new.xml
  def new
    @stat = Stat.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @stat }
    end
  end

  # GET /stats/1/edit
  def edit
    @stat = Stat.find(params[:id])
  end

  # POST /stats
  # POST /stats.xml
  def create
    @stat = Stat.new(params[:stat])

    respond_to do |format|
      if @stat.save
        flash[:notice] = 'Stat was successfully created.'
        format.html { redirect_to(@stat) }
        format.xml  { render :xml => @stat, :status => :created, :location => @stat }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @stat.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stats/1
  # PUT /stats/1.xml
  def update
    @stat = Stat.find(params[:id])

    respond_to do |format|
      if @stat.update_attributes(params[:stat])
        flash[:notice] = 'Stat was successfully updated.'
        format.html { redirect_to(@stat) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stat.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stats/1
  # DELETE /stats/1.xml
  def destroy
    @stat = Stat.find(params[:id])
    @stat.destroy

    respond_to do |format|
      format.html { redirect_to(stats_url) }
      format.xml  { head :ok }
    end
  end
  
  def sort_table
    
    table_order = params[:stat] + " " + params[:order]
    
    @stats = Stat.find(:all, :order => table_order, :limit => 25)
    
    if params[:order] == "desc"
      @order = "asc"
    else
      @order = "desc"
    end
    
#    if order == "desc"
#      @stats = Stat.find(:all, :order => "avg DESC", :limit => 25)
#      @order = "asc"
#    else
#      @stats = Stat.find(:all, :order => "avg ASC", :limit => 25)
#      @order ="desc"
#    end

    respond_to do |format|
      format.js
    end
    
  end
  
  def load_xml
  end
  
  def import_xml
    
    file = params[:document][:file]
    doc = Document.new(file.read)

    XPath.each(doc, "SEASON") do |season|
      year = season.elements['YEAR'].text
      imp_year = Year.find_by_year( year )
      if not imp_year
        imp_year = Year.create(:year => year)
      end
      
      XPath.each(season, "LEAGUE") do |league|
        league_name = league.elements['LEAGUE_NAME'].text
        imp_league = League.find_by_league_name( league_name )
        if not imp_league
          imp_league = League.create(:league_name => league_name)
        end
        
        XPath.each(league, "DIVISION") do |division|
          division_name = division.elements['DIVISION_NAME'].text
          imp_division = Division.find_by_division_name( division_name )
          if not imp_division
            imp_division = Division.create(:division_name => division_name, :league_id => imp_league.id)
          end
          
          XPath.each(division, "TEAM") do |team|
            team_city = team.elements['TEAM_CITY'].text
            team_name = team.elements['TEAM_NAME'].text
            imp_team = Team.find_by_team_name( team_name )
            if not imp_team
              imp_team = Team.create( :team_city => team_city, :team_name => team_name, :division_id => imp_division.id )
            end
            
            XPath.each(team, "PLAYER") do |player|
              given_name = player.elements['GIVEN_NAME'].text
              surname = player.elements['SURNAME'].text
              position = player.elements['POSITION'].text
              
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
                
                # check that player has been at bat 
                if at_bats > 0
                  total_bases = (doubles * 2) + (triples * 3) + (home_runs * 4)
                  singles = hits - total_bases
                  total_bases = total_bases + singles
                  
                  top_equ = at_bats * ( hits + walks + hit_by_pitch) + total_bases * (at_bats + walks + sacrifice_flies + hit_by_pitch)
                  bottom_equ = at_bats * ( at_bats + walks + sacrifice_flies + hit_by_pitch)
                  ops = top_equ / bottom_equ
                else
                  ops = 0.00
                end
                puts format("#{ops} to OPS %.3f\n",ops)
                
                puts "HOME RUNS: #{home_runs.to_i}"
    
                imp_player = Player.find(:first, :conditions => ["given_name = ? and surname = ? and position = ?", given_name, surname, position])
                if not imp_player
                  imp_player = Player.create(:given_name => given_name, :surname => surname, :position => position)
                end
                
#								imp_stat = Stat.find(:all, :conditions => ["imp_year.id = :year_id and imp_player.id = :player_id and imp_team.id = :team_id"])
                imp_stat = Stat.find(:first, :conditions => ["year_id = ? and player_id = ? and team_id = ?", imp_year.id, imp_player.id, imp_team.id])
                if not imp_stat
                  imp_stat = Stat.create(:year_id => imp_year.id, :player_id => imp_player.id, :team_id => imp_team.id,
                                          :avg => avg, :hr => home_runs, :rbi => rbi, :runs => runs, :sb => steals, :ops => ops)
                end
    
              end

            end
          end
        end
      end
    end
    
    redirect_to :action => 'index'
  end			  
end
