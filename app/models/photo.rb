class Photo < ActiveRecord::Base
  attr_accessible :attribution, :description, :height, :imageable_id, :imageable_type, :photo, :photo_content_type, :photo_file_size, :title, :user_id, :width
end
