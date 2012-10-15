class WorkZone < ActiveRecord::Base
  attr_accessible :abbreviation, :leader_id, :name, :photo, :region_id, :remove_photo

  # elasticsearch indexing
  include Tire::Model::Search
  include Tire::Model::Callbacks
  index_name ELASTICSEARCH_INDEX
  mapping do
    indexes :handle, :as => 'name'
    indexes :abbreviation
    indexes :leader, :as => proc { |w| w.leader.user.name if w.leader? }
    indexes :name
    indexes :region_id, :as => proc { |w| w.region.name }
  end

  mount_uploader :photo, PhotoUploader

  validates :abbreviation, :length => {:minimum => 2, :maximum => 8}, :uniqueness => {:case_sensitive => false}
  validates :leader_id, :numericality => {:is_integer => true}, :allow_blank => true
  validates :region_id, :numericality => {:is_integer => true}
  validates :name, :presence => true, :length => {:maximum => 255}, :uniqueness => {:case_sensitive => false, :scope => :region_id}
  validates :region_id, :numericality => {:is_integer => true}

  before_validation :do_before_validation

  belongs_to :region
  belongs_to :leader, :class_name => 'Volunteer'
  has_many :volunteers, :dependent => :nullify
  has_many :users, :through => :volunteers

  default_scope :order => 'name ASC'

  def leader?
    !leader.nil?
  end

  def region?
    !region.nil?
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  private

    def do_before_validation
      self.abbreviation = abbreviation.upcase
    end

end
