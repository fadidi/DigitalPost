class Volunteer < ActiveRecord::Base
  attr_accessible :cos_date, :local_name, :sector_id, :service_info_html, 
    :service_info_markdown, :site, :stage_id, :user_id, :work_zone_id

  validates :user_id, :numericality => { :is_integer => true }, :uniqueness => true
  validates :stage_id, :sector_id, :work_zone_id, :numericality => { :is_integer => true }, :allow_blank => true
  validates :cos_date, :date => true, :allow_blank => true
  validates :local_name, :length => { :maximum => 255 }, :allow_blank => true

  belongs_to :sector
  belongs_to :stage
  belongs_to :user
  belongs_to :work_zone
  has_one :region, :through => :work_zone
  has_one :lead_work_zone, :class_name => 'WorkZone', :foreign_key => :leader_id, :dependent => :nullify

  before_save :do_before_save

  def region?
    work_zone? ? (work_zone.region? ? true : false) : false
  end

  def sector?
    !sector.nil?
  end

  def stage?
    !stage.nil?
  end

  def to_param
    "#{user.id}-#{user.name.parameterize}"
  end

  def user_name
    user.name
  end

  def work_zone?
    !work_zone.nil?
  end

  private

    def do_before_save
      self.service_info_html = Markdown.render(service_info_markdown)
    end
end
