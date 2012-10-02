class CreateWorkZones < ActiveRecord::Migration
  def change
    create_table :work_zones do |t|
      t.string :abbreviation
      t.string :name
      t.integer :leader_id
      t.integer :region_id

      t.timestamps
    end

    add_index :work_zones, [:name, :region_id], :unique => true
    add_index :work_zones, :abbreviation, :unique => true
  end
end
