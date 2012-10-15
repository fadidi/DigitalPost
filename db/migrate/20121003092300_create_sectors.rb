class CreateSectors < ActiveRecord::Migration
  def change
    create_table :sectors do |t|
      t.string :abbreviation
      t.integer :apcd_id
      t.string :name
      t.string :photo

      t.timestamps
    end

    add_index :sectors, :abbreviation, :unique => true
    add_index :sectors, :name, :unique => true
  end
end
