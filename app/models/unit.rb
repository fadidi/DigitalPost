class Unit < ActiveRecord::Base
  attr_accessible :description, :head_id, :name

  validates :name, :presence => true, :length => { :maximum => 255 }, :uniqueness => { :case_sensitive => false }
  validates :head_id, :numericality => { :is_integer => true }, :allow_blank => true

  belongs_to :head, :class_name => 'User', :foreign_key => :head_id
  has_many :staff
  has_many :users, :through => :staff

  def head?
    !head.nil?
  end

end
