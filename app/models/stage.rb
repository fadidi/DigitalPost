class Stage < ActiveRecord::Base
  attr_accessible :anticipated_cos, :arrival, :swear_in

  validates :anticipated_cos, :arrival, :swear_in, :date => true, :uniqueness => true

  has_many :volunteers
  has_many :users, :through => :volunteers


  def name
    arrival.blank? ? nil : arrival.strftime('%B %Y')
  end

  after_initialize :do_after_initialize

  private

    def do_after_initialize
      self.anticipated_cos ||= Time.now + 820.days
      self.arrival ||= Time.now
      self.swear_in ||= Time.now + 90.days
    end

end
