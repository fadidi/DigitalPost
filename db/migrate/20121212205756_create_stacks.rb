class CreateStacks < ActiveRecord::Migration
  def change
    create_table :stacks do |t|
      t.integer :library_id
      t.references :stackable, :polymorphic => true
      t.integer :user_id

      t.timestamps
    end
  end
end
