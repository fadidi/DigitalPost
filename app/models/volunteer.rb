class Volunteer < ActiveRecord::Base
  attr_accessible :cos_date, :local_name, :sector_id, :service_info, :site, :stage_id, :user_id
end
