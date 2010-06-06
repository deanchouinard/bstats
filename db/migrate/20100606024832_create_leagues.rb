class CreateLeagues < ActiveRecord::Migration
  def self.up
    create_table :leagues do |t|
      t.string :league_name, :limit => 20

      t.timestamps
    end
  end

  def self.down
    drop_table :leagues
  end
end
