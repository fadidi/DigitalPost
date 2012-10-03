class CreateSectors < ActiveRecord::Migration
  def change
    create_table :sectors do |t|
      t.integer :apcd_id
      t.string :name

      t.timestamps
    end

    add_index :sectors, :name, :unique => true
  end
end
