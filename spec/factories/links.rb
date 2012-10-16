# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :link do
    language
    sequence(:url) { |n| "http://www.test#{n}.com" }
    user
  end
end
