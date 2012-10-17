# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :timeline do
    asset_caption "MyString"
    asset_credit "MyString"
    asset_media "MyText"
    sequence(:headline) { |n| "Timeline Headline #{n}" }
    startdate "2012-10-17"
    text "MyText"
  end
end
