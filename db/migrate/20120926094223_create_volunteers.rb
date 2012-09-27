class CreateVolunteers < ActiveRecord::Migration
  def change
    create_table :volunteers do |t|
      t.integer :user_id
      t.text :service_info_html
      t.text :service_info_markdown, :default => 'No service info provided.'
      t.integer :stage_id
      t.string :local_name
      t.string :site
      t.integer :sector_id
      t.date :cos_date
      t.integer :work_zone_id

      t.timestamps
    end

    add_index :volunteers, :user_id, :unique => true
  end
end
