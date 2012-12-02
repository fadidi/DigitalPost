class CreateLibraries < ActiveRecord::Migration
  def change
    create_table :libraries do |t|
      t.text :description
      t.string :name
      t.integer :owner_id

      t.timestamps
    end
  end
end
