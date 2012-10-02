# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :work_zone do
    sequence(:abbreviation) {|n| "A#{n}D"}
    name
    sequence(:region_id) {|n| n}
  end
end
