class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :avatar
      t.string :name
      t.integer :head_id
      t.text :description

      t.timestamps
    end
  end
end
