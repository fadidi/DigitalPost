class CreateWorkZones < ActiveRecord::Migration
  def change
    create_table :work_zones do |t|
      t.string :abbreviation
      t.integer :leader_id
      t.string :name
      t.string :photo
      t.integer :region_id

      t.timestamps
    end

    add_index :work_zones, [:name, :region_id], :unique => true
    add_index :work_zones, :abbreviation, :unique => true
  end
end
