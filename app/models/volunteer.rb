class Volunteer < ActiveRecord::Base
  attr_accessible :cos_date, :local_name, :sector_id, :service_info_html, 
    :service_info_markdown, :site, :stage_id, :user_id, :work_zone_id

  belongs_to :user

  validates :user_id, :numericality => { :is_integer => true }, :uniqueness => true
  validates :stage_id, :sector_id, :work_zone_id, :numericality => { :is_integer => true }, :allow_blank => true
  validates :cos_date, :date => true, :allow_blank => true

  before_save :do_before_save

  def to_param
    "#{user.id}-#{user.name.parameterize}"
  end

  private

    def do_before_save
      self.service_info_html = Markdown.render(service_info_markdown)
    end
end
