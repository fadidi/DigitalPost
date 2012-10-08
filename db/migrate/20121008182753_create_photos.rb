class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :attribution
      t.text :description
      t.integer :height
      t.integer :imageable_id
      t.string :imageable_type
      t.string :photo
      t.string :photo_content_type
      t.integer :photo_file_size
      t.string :title
      t.integer :user_id
      t.integer :width

      t.timestamps
    end
  end
end
