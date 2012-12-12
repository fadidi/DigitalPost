class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :author
      t.string :file
      t.string :file_content_type
      t.integer :file_file_size
      t.string :file_hash
      t.text :description
      t.integer :language_id
      t.string :title
      t.string :photo
      t.boolean :restricted, :default => false
      t.string :source
      t.string :source_content_type
      t.integer :source_file_size
      t.integer :user_id

      t.timestamps
    end
  end
end
