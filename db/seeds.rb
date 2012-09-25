# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# create default users
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create!(
  :name => 'Jack Brown',
  :email => 'jack@brownjohnf.com',
  :password => 'password',
  :password_confirmation => 'password'
)
puts 'New user created: ' << user.name

ValidEmail.create!([{
  :email => 'jack@brownjohnf.com',
  :permissions => 'admin,volunteer'
}])

# create default page
puts 'CREATING DEFAULT PAGES'
Page.create([{
  :country_id => 1,
  :title => 'Default Page',
  :html => '<p>You should edit this page, or replace it with a better page...</p>'
}])
