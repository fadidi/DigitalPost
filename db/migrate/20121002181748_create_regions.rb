class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :name
      t.string :abbreviation
      t.string :photo

      t.timestamps
    end

    add_index :regions, :name, :unique => true
    add_index :regions, :abbreviation, :unique => true
  end
end
