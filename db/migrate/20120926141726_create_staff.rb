class CreateStaff < ActiveRecord::Migration
  def change
    create_table :staff do |t|
      t.integer :user_id
      t.string :location
      t.text :job_description

      t.timestamps
    end
  end
end
