class Sector < ActiveRecord::Base
  attr_accessible :abbreviation, :apcd_id, :name, :photo, :remove_photo

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

  validates :abbreviation, :length => {:minimum => 2, :maximum => 7}, :uniqueness => {:case_sensitive => false}
  validates :apcd_id, :numericality => { :is_integer => true }, :allow_blank => true
  validates :name, :length => { :maximum => 255 }, :uniqueness => { :case_sensitive => false }, :presence => true

  belongs_to :apcd, :class_name => 'Staff'

  has_many :volunteers, :dependent => :nullify
  has_many :users, :through => :volunteers

  before_validation :do_before_validation

  default_scope :order => 'name ASC'

  def apcd?
    !apcd.nil?
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  private
    
    def do_before_validation
      self.abbreviation = abbreviation.upcase
    end

end
