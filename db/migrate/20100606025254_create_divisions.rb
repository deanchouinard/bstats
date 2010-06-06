class CreateDivisions < ActiveRecord::Migration
  def self.up
    create_table :divisions do |t|
      t.string :division_name, :limit => 20

      t.timestamps
    end
  end

  def self.down
    drop_table :divisions
  end
end
