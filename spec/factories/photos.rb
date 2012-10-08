# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :photo do
    attribution "MyString"
    description "MyText"
    height 1
    imageable_id 1
    imageable_type "MyString"
    photo "MyString"
    photo_content_type "MyString"
    photo_file_size 1
    title "MyString"
    user_id 1
    width 1
  end
end
