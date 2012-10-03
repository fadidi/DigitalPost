FactoryGirl.define do
  
  sequence :email do |n|
    "test-#{n}@example.com"
  end

  sequence :name do |n|
    "Test Name #{n}"
  end

  sequence :content do |n|
    "Fresh content number #{n}!"
  end

  sequence :title do |n|
    "Shiny Title Number #{n}"
  end

  sequence :abbreviation do |n|
    "A#{n}C"
  end

end
