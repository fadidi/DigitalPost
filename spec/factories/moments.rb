# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :moment do
    headline "MyString"
    startdate "2012-10-17"
    timeline
    user
  end
end
