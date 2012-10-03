# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :language do
    code { FactoryGirl.generate :abbreviation }
    name
  end
end
