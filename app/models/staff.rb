class Staff < ActiveRecord::Base
  attr_accessible :job_description, :location, :user_id
end
