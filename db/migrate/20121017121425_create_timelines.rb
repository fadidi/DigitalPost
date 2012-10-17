class CreateTimelines < ActiveRecord::Migration
  def change
    create_table :timelines do |t|
      t.string :asset_caption
      t.string :asset_credit
      t.text :asset_media
      t.string :headline
      t.date :startdate
      t.text :text
      t.string :ttype, :default => 'default'

      t.timestamps
    end

    add_index :timelines, :headline, :unique => true
  end
end
