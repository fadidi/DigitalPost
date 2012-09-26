class CreateVolunteers < ActiveRecord::Migration
  def change
    create_table :volunteers do |t|
      t.integer :user_id
      t.string :service_info_html
      t.string :service_info_markdown, :default => 'No service info provided.'
      t.string :stage_id
      t.string :local_name
      t.string :site
      t.integer :sector_id
      t.date :cos_date

      t.timestamps
    end
  end
end
