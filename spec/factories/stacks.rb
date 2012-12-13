# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stack do
    library
    stackable_id 1
    stackable_type "Document"
    user
  end
end
