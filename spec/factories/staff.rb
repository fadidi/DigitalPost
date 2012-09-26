# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :staff do
    user_id 1
    location "MyString"
    job_description "MyText"
  end
end
