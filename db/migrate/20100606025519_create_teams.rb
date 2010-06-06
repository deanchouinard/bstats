class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.string :team_city, :limit => 20
      t.string :team_name, :limit => 20

      t.timestamps
    end
  end

  def self.down
    drop_table :teams
  end
end
