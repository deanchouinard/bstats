class CreateStats < ActiveRecord::Migration
  def self.up
    create_table :stats do |t|
			t.integer :year_id
			t.integer :player_id
			t.integer :team_id
			t.float   :avg
			t.integer :hr
			t.integer :rbi
			t.integer :runs
			t.integer :sb
			t.float   :ops
			
      t.timestamps
    end
  end

  def self.down
    drop_table :stats
  end
end
