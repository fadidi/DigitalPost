class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.text :description
      t.integer :language_id
      t.string :name
      t.text :url
      t.integer :user_id

      t.timestamps
    end

    add_index :links, :url, :unique => true
  end
end
