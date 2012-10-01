class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.date :anticipated_cos
      t.date :arrival
      t.date :swear_in

      t.timestamps
    end

    add_index :stages, :anticipated_cos, :unique => true
    add_index :stages, :arrival, :unique => true
    add_index :stages, :swear_in, :unique => true
  end
end
