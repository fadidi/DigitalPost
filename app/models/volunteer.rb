class Volunteer < ActiveRecord::Base
  attr_accessible :cos_date, :local_name, :sector_id, :service_info_html, :service_info_markdown, :site, :stage_id, :user_id

  belongs_to :user

  validates :user_id, :presence => true

  before_save :do_before_save

  private

    def do_before_save
      self.service_info_html = Markdown.render(service_info_markdown)
    end
end
