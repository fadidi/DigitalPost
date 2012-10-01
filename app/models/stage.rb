class Stage < ActiveRecord::Base
  attr_accessible :anticipated_cos, :arrival, :swear_in

  validates :anticipated_cos, :arrival, :swear_in, :date => true, :uniqueness => true

  has_many :volunteers
  has_many :users, :through => :volunteers

  default_scope :order => 'arrival DESC'

  after_initialize :do_after_initialize

  self.per_page = 20

  def name
    arrival.blank? ? nil : arrival.strftime('%B %Y')
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end
  
  private

    def do_after_initialize
      self.anticipated_cos ||= Date.today + 820.days
      self.arrival ||= Date.today
      self.swear_in ||= Date.today + 90.days
    end

end
