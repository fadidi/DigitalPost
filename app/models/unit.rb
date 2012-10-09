class Unit < ActiveRecord::Base
  attr_accessible :description, :head_id, :name, :photo, :photo_content_type, :photo_file_size, :photo_hash, :remove_photo
  
  # elasticsearch indexing
  include Tire::Model::Search
  include Tire::Model::Callbacks
  index_name ELASTICSEARCH_INDEX
  mapping do
    indexes :handle, :as => 'name'
    indexes :description
    indexes :name
  end

  mount_uploader :photo, PhotoUploader

  validates :photo,
    :file_size => {
      :maximum => 10.megabytes.to_i
    }
  validates :photo_file_size,
    :numericality => { :is_integer => true },
    :allow_blank => true
  validates :name,
    :presence => true,
    :length => { :maximum => 255 },
    :uniqueness => { :case_sensitive => false }
  validates :head_id,
    :numericality => { :is_integer => true },
    :allow_blank => true
  validates :description,
    :length => { :maximum => 255 },
    :allow_blank => true

  belongs_to :head, :class_name => 'Staff', :foreign_key => :head_id
  has_many :staff, :dependent => :nullify
  has_many :users, :through => :staff

  default_scope :order => 'name ASC'

  def head?
    !head.nil?
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

end
