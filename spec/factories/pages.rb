# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page, :aliases => [:link_target, :link_source] do
    title
    user
  end
end
