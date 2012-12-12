class CreateLibraries < ActiveRecord::Migration
  def change
    create_table :libraries do |t|
      t.text :description
      t.string :name
      t.integer :owner_id
      t.string :photo
      t.boolean :restricted, :default => false

      t.timestamps
    end
  end
end
