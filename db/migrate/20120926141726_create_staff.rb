class CreateStaff < ActiveRecord::Migration
  def change
    create_table :staff do |t|
      t.integer :user_id
      t.string :location
      t.text :job_description_html
      t.text :job_description_markdown, :default => 'No job description.'
      t.string :job_title
      t.integer :unit_id

      t.timestamps
    end

    add_index :staff, :user_id, :unique => true
  end
end
