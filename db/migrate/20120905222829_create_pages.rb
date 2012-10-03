class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :language_id, :default => 1
      t.string :title
      t.text :html, :default => '<p>No content.</p>'
      t.integer :locked_by
      t.datetime :locked_at
      t.integer :user_id

      t.timestamps
    end

    add_index :pages, :title
  end
end
