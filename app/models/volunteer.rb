class Volunteer < ActiveRecord::Base

  # elasticsearch indexing
  include Tire::Model::Search
  include Tire::Model::Callbacks
  index_name ELASTICSEARCH_INDEX
  mapping do
    indexes :primary, :as => 'local_name'
    indexes :service_info_html
    indexes :site
  end

  attr_accessible :cos_date, :local_name, :sector_id, :service_info_html, 
    :service_info_markdown, :site, :stage_id, :user_id, :work_zone_id

  belongs_to :stage
  belongs_to :user
  belongs_to :work_zone

  validates :user_id, :numericality => { :is_integer => true }, :uniqueness => true
  validates :stage_id, :sector_id, :work_zone_id, :numericality => { :is_integer => true }, :allow_blank => true
  validates :cos_date, :date => true, :allow_blank => true
  validates :local_name, :length => { :maximum => 255 }, :allow_blank => true

  before_save :do_before_save

  def region?
    work_zone? ? (work_zone.region? ? true : false) : false
  end

  def stage?
    !stage.nil?
  end

  def to_param
    "#{user.id}-#{user.name.parameterize}"
  end

  def work_zone?
    !work_zone.nil?
  end

  private

    def do_before_save
      self.service_info_html = Markdown.render(service_info_markdown)
    end
end
