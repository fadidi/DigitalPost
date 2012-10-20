# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :document do
    file { File.open('spec/support/documents/sample.txt') }
    language
    user
  end
end
