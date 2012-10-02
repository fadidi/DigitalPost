# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :region do
    name
    sequence(:abbreviation) {|n| "A#{n}C" }
  end
end
