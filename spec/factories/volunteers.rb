# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :volunteer, :aliases => [:leader] do
    user
    stage
    sector
    work_zone
  end
end
