# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :case_study do
    approach "MyText"
    challenges "MyText"
    context "MyText"
    lessons "MyText"
    language
    recommendations "MyText"
    results "MyText"
    summary "MyText"
    title
  end
end
