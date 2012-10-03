class Language < ActiveRecord::Base
  attr_accessible :code, :description, :name
end
