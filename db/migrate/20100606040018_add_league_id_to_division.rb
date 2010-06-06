class AddLeagueIdToDivision < ActiveRecord::Migration
  def self.up
    add_column :divisions, :league_id, :integer
  end

  def self.down
    remove_column :divisions, :league_id
  end
end
