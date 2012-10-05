class AddMetadataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string
    add_column :users, :avatar_content_type, :string
    add_column :users, :avatar_file_size, :string
    add_column :users, :bio, :text, :default => nil
    add_column :users, :bio_markdown, :text, :default => 'This user has no bio.'
    add_column :users, :blog_title, :string
    add_column :users, :blog_url, :string
    add_column :users, :phone, :string
    add_column :users, :website, :string

    add_index :users, :name ,:unique => true
  end
end
