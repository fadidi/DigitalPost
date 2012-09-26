# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :volunteer do
    user_id 1
    service_info "MyString"
    stage_id "MyString"
    local_name "MyString"
    site "MyString"
    sector_id 1
    cos_date "2012-09-26"
  end
end
