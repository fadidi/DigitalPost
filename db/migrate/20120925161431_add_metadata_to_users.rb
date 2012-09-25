class AddMetadataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bio, :text, :default => nil
    add_column :users, :bio_markdown, :text, :default => 'This user has no bio.'
    add_column :users, :phone, :string
  end
end
