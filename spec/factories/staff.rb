# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :staff, :aliases => [:apcd] do
    user
    unit
  end
end
