# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stage do
    sequence(:anticipated_cos) {|n| Time.now + 820.days + n.seconds}
    sequence(:arrival) {|n| Time.now + n.seconds}
    sequence(:swear_in) {|n| Time.now + 90.days + n.seconds}
  end
end
