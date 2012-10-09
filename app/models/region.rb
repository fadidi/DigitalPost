class Region < ActiveRecord::Base
  attr_accessible :abbreviation, :name, :photo

  # elasticsearch indexing
  include Tire::Model::Search
  include Tire::Model::Callbacks
  index_name ELASTICSEARCH_INDEX
  mapping do
    indexes :handle, :as => 'name'
    indexes :abbreviation
    indexes :name
  end

  mount_uploader :photo, PhotoUploader

  validates :abbreviation, :length => {:minimum => 2, :maximum => 8}, :uniqueness => {:case_sensitive => false}
  validates :name, :length => {:maximum => 255}, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :photo,
    :file_size => {
      :maximum => 10.megabytes.to_i
    }

  has_many :work_zones, :dependent => :destroy
  has_many :volunteers, :through => :work_zones
  has_many :users, :through => :volunteers

  default_scope :order => 'name ASC'

  def work_zones?
    work_zones.any?
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  private
    
    before_validation do |region|
      region.abbreviation = region.abbreviation.upcase
    end

end
