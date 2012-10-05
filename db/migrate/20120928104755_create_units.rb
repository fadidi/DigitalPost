class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.text :description
      t.integer :head_id
      t.string :name
      t.string :photo
      t.string :photo_content_type
      t.string :photo_file_size

      t.timestamps
    end
  end
end
