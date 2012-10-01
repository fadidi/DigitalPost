# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stage do
    sequence(:anticipated_cos) {|n| Date.today + 820.days + n.days}
    sequence(:arrival) {|n| Date.today + n.days}
    sequence(:swear_in) {|n| Date.today + 90.days + n.days}
  end
end
