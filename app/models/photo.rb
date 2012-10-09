class Photo < ActiveRecord::Base
  attr_accessible :attribution, :description, :height, :imageable_id, :imageable_type, :photo, :photo_content_type, :photo_file_size, :photo_hash, :title, :user_id, :width

  validates :attribution, :title,
    :length => { :maximum => 255 }
  validates :height, :photo_file_size, :user_id, :width,
    :numericality => { :is_integer => true }
  validates :imageable_id,
    :numericality => { :is_integer => true },
    :allow_blank => true
  validates :imageable_type,
    :length => { :maximum => 255 }
  validates :photo_content_type, :photo_hash,
    :length => { :maximum => 255 },
    :presence => true
  validates :photo,
    :presence => true

end
