class AddDivisionIdToTeam < ActiveRecord::Migration
  def self.up
    add_column :teams, :division_id, :integer
  end

  def self.down
    remove_column :teams, :division_id
  end
end
