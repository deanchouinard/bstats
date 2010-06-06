class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :given_name, :limit => 20
      t.string :surname, :limit => 40
      t.string :position, :limit => 20

      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
