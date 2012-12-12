class Library < ActiveRecord::Base
  attr_accessible :description, :name, :owner_id, :photo, :remove_photo, :restricted

  # elasticsearch indexing
  include Tire::Model::Search
  include Tire::Model::Callbacks
  index_name ELASTICSEARCH_INDEX
  mapping do
    indexes :handle, :as => 'name'
    indexes :description
    indexes :name
    indexes :owner, :as => proc { |l| l.owner.name if l.owner? }
  end

  mount_uploader :photo, PhotoUploader

  validates :name, :presence => true, :length => { :maximum => 255 }
  validates :owner_id,
    :numericality => { :is_integer => true },
    :allow_blank => true
  validates :photo,
    :file_size => {
      :maximum => 10.megabytes.to_i
    }

  belongs_to :owner, :class_name => 'User', :foreign_key => :owner_id

  default_scope :order => 'name ASC'

  def owner?
    !owner.nil?
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

end
