class CreateCaseStudies < ActiveRecord::Migration
  def change
    create_table :case_studies do |t|
      t.text :approach
      t.text :challenges
      t.text :context
      t.text :html
      t.text :lessons
      t.integer :language_id
      t.text :recommendations
      t.text :results
      t.text :summary
      t.string :title

      t.timestamps
    end

    add_index :case_studies, :title, :unique => true
  end
end
