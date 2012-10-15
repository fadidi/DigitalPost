class Photo < ActiveRecord::Base
  attr_accessible :attribution, :description, :photo_height, :imageable_id, :imageable_type, :photo, :photo_content_type, :photo_file_size, :photo_hash, :title, :user_id, :photo_width

  # elasticsearch indexing
  include Tire::Model::Search
  include Tire::Model::Callbacks
  index_name ELASTICSEARCH_INDEX
  mapping do
    indexes :handle, :as => 'title'
    indexes :attribution
    indexes :description
    indexes :photo_height
    indexes :photo_content_type
    indexes :photo_file_size
    indexes :title
    indexes :photo_width
  end

  mount_uploader :photo, PhotoUploader

  validates :attribution, :title,
    :length => { :maximum => 255 }
  validates :photo_height, :user_id, :photo_width,
    :numericality => { :is_integer => true }
  validates :imageable_id,
    :numericality => { :is_integer => true },
    :allow_blank => true
  validates :imageable_type,
    :length => { :maximum => 255 }
  validates :photo_content_type,
    :length => { :maximum => 255 },
    :presence => true
  validates :photo_hash,
    :length => { :maximum => 255 },
    :presence => true,
    :uniqueness => { :case_sensitive => false }
  validates :photo,
    :file_size => { :maximum => 10.megabytes.to_i },
    :presence => true

  belongs_to :user

  def to_param
    "#{id}-#{title.parameterize}"
  end

  private

    before_save do |this_photo|
      this_photo.title = this_photo.photo.file.original_filename if this_photo.title.blank?
    end

end
