# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'SETTING UP DEFAULT UNITS'
# warning! need to update lib/tasks/load_sample_data if you change the names of these!
Unit.create!([{
  :name => 'Administrative',
  :description => 'The Administrative unit is responsible for the operations and management of the Post.',
},{
  :name => 'Programming',
  :description => 'The programming unit is responsible for directing the actions and goals of the Post.',
},{
  :name => 'Training',
  :description => 'The training unit is responsible for PST, IST, and the ongoing education of Volunteers.',
},{
  :name => 'Safety & Security',
  :description => 'The safety & security unit is responsible for educating Volunteers about staying safe, and dealing with crises if they occur.',
},{
  :name => 'Medical',
  :description => 'The medical unit is responsible for preventative and treatment healthcare for PCVs throughout their training and service.',
}])
# create default users
puts 'SETTING UP DEFAULT USER LOGIN'
User.create!([{
  :name => 'Fadidi Media Admin',
  :email => 'jack@brownjohnf.com',
  :password => 'password',
  :password_confirmation => 'password',
  :bio_markdown => 'Founder and lead developer at Fadidi Digital Media.',
  :website => 'http://www.fadidi.com'
}])

ValidEmail.create!([{
  :email => 'jack@brownjohnf.com',
  :permissions => 'admin'
}])

# create default page
puts 'CREATING DEFAULT PAGES'
Page.create!([{
  :title => 'Default Page',
  :html => '<p>You should edit this page, or replace it with a better page...</p>',
  :user_id => 1
}])
