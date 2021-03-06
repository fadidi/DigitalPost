class Staff < ActiveRecord::Base
  attr_accessible :job_description_html, :job_description_markdown, :job_title, :location, :user_id, :unit_id

  belongs_to :user
  belongs_to :unit

  has_many :sectors, :foreign_key => :apcd_id, :dependent => :nullify

  validates :user_id, :presence => true, :numericality => { :is_integer => true }, :uniqueness => true
  validates :unit_id, :numericality => { :is_integer => true }, :allow_blank => true
  validates :job_title, :length => { :maximum => 255 }, :allow_blank => true

  before_save :do_before_save

  def name
    user.name
  end

  def to_param
    "#{user.id}-#{user.name.parameterize}"
  end

  def unit?
    !unit.nil?
  end

  private

    def do_before_save
      self.job_description_html = Markdown.render(job_description_markdown)
    end
end
