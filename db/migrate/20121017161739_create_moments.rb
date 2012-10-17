class CreateMoments < ActiveRecord::Migration
  def change
    create_table :moments do |t|
      t.string :asset_caption
      t.string :asset_credit
      t.text :asset_media
      t.string :headline
      t.date :startdate
      t.date :enddate
      t.text :text
      t.integer :timeline_id
      t.integer :user_id

      t.timestamps
    end
  end
end
