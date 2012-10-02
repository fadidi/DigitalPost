class WorkZone < ActiveRecord::Base
  attr_accessible :abbreviation, :leader_id, :name, :region_id

  validates :abbreviation, :length => {:minimum => 2, :maximum => 8}, :uniqueness => {:case_sensitive => false}
  validates :leader_id, :numericality => {:is_integer => true}, :allow_blank => true
  validates :region_id, :numericality => {:is_integer => true}
  validates :name, :presence => true, :length => {:maximum => 255}, :uniqueness => {:case_sensitive => false, :scope => :region_id}
  validates :region_id, :numericality => {:is_integer => true}

  before_validation :do_before_validation

  belongs_to :region
  belongs_to :leader, :class_name => 'User'
  has_many :volunteers
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
