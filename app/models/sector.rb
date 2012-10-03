class Sector < ActiveRecord::Base
  attr_accessible :apcd_id, :name

  validates :apcd_id, :numericality => { :is_integer => true }, :allow_blank => true
  validates :name, :length => { :maximum => 255 }, :uniqueness => { :case_sensitive => false }, :presence => true

  belongs_to :apcd, :class_name => 'Staff'

  has_many :volunteers
  has_many :users, :through => :volunteers

  def apcd?
    !apcd.nil?
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end
end
