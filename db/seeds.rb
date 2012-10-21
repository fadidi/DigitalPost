# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# this has a lot of sleeps because of the searchbox api query limit.

[{
  :email => 'jack@brownjohnf.com',
  :permissions => 'admin'
}].each do |email|
  ValidEmail.where(:email => email[:email]).first_or_create!(email)
  puts 'pausing...'
  sleep 1
end

# create default users
puts 'SETTING UP DEFAULT USER LOGIN'
[{
  :name => 'Fadidi Media Admin',
  :email => 'jack@brownjohnf.com',
  :password => 'password',
  :password_confirmation => 'password',
  :bio_markdown => 'Founder and lead developer at Fadidi Digital Media.',
  :website => 'http://www.fadidi.com'
}].each do |user|
  User.where(:email => user[:email]).first_or_create!(user)
  puts 'pausing...'
  sleep 1
end

puts 'SETTING UP LANGUAGES...'
[{
  :code => 'EN',
  :name => 'English'
}].each do |language|
  Language.where(:code => language[:code]).first_or_create!(language)
  puts 'pausing...'
  sleep 1
end

puts 'SETTING UP DEFAULT UNITS...'
# warning! need to update lib/tasks/load_sample_data if you change the names of these!
[{
  :name => 'Administrative',
  :description => 'The Administrative unit is responsible for the operations and management of the Post.'
},{
  :name => 'Programming',
  :description => 'The programming unit is responsible for directing the actions and goals of the Post.'
},{
  :name => 'Training',
  :description => 'The training unit is responsible for PST, IST, and the ongoing education of Volunteers.'
},{
  :name => 'Safety & Security',
  :description => 'The safety & security unit is responsible for educating Volunteers about staying safe, and dealing with crises if they occur.'
},{
  :name => 'Medical',
  :description => 'The medical unit is responsible for preventative and treatment healthcare for PCVs throughout their training and service.'
}].each do |unit|
  Unit.where(:name => unit[:name]).first_or_create!(unit)
  puts 'pausing...'
  sleep 1
end

# create default page
puts 'CREATING DEFAULT PAGES...'
[{
  :title => 'Default Page',
  :html => '<p>You should edit this page, or replace it with a better page...</p>',
  :user_id => 1
}].each do |page|
  Page.where(:title => page[:title]).first_or_create!(page)
  puts 'pausing...'
  sleep 1
end

puts 'CREATING DEFAULT LINKS...'
[{
  :description => 'Fadidi Digital Media',
  :language_id => Language.find_by_code('EN').id,
  :name => 'Fadidi Digital Media',
  :url => 'http://www.fadidi.com'
},{
  :description => 'Home base for Peace Corps Senegal.',
  :language_id => Language.find_by_code('EN').id,
  :name => 'Peace Corps|Senegal',
  :url => 'http://www.pcsenegal.org'
},{
  :description => 'Learn all about Peace Corps!',
  :language_id => Language.find_by_code('EN').id,
  :name => 'Peace Corps Washington',
  :url => 'http://www.peacecorsp.gov'
}].each do |link|
  Link.where(:url => link[:url]).first_or_create!(link.merge(:user_id => User.first.id, :language_id => Language.find_by_code('EN').id))
  puts 'pausing...'
  sleep 1
end
