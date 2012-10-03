class Region < ActiveRecord::Base

  # elasticsearch indexing
  include Tire::Model::Search
  include Tire::Model::Callbacks
  index_name ELASTICSEARCH_INDEX
  mapping do
    indexes :handle, :as => 'name'
    indexes :abbreviation
    indexes :name
  end

  attr_accessible :abbreviation, :name

  validates :abbreviation, :length => {:minimum => 2, :maximum => 8}, :uniqueness => {:case_sensitive => false}
  validates :name, :length => {:maximum => 255}, :presence => true, :uniqueness => {:case_sensitive => false}

  has_many :work_zones, :dependent => :destroy
  has_many :volunteers, :through => :work_zones
  has_many :users, :through => :volunteers

  default_scope :order => 'name ASC'

  before_validation :do_before_validation

  def work_zones?
    work_zones.any?
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  private
    
    def do_before_validation
      self.abbreviation = abbreviation.upcase
    end

end
