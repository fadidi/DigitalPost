class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :attribution
      t.text :description
      t.integer :height
      t.references :imageable, :polymorphic => true
      t.string :photo
      t.string :photo_content_type
      t.integer :photo_file_size
      t.string :photo_hash
      t.string :title
      t.references :user
      t.integer :width

      t.timestamps
    end

    add_index :photos, :photo_hash, :unique => true
  end
end
