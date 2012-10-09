# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :photo do
    height 1
    imageable_id 1
    imageable_type "MyString"
    photo { File.open('spec/support/images/10x10.gif') }
    user
    width 1
    photo_content_type 'test'
  end
end
