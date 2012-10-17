class Moment < ActiveRecord::Base
  attr_accessible :asset_caption, :asset_credit, :asset_media, :enddate, :headline, :startdate, :text, :timeline_id, :user_id

  # elasticsearch indexing
  include Tire::Model::Search
  include Tire::Model::Callbacks
  index_name ELASTICSEARCH_INDEX
  mapping do
    indexes :handle, :as => 'headline'
    indexes :asset_caption
    indexes :asset_credit
    indexes :asset_media
    indexes :enddate
    indexes :headline
    indexes :startdate
    indexes :text
    indexes :timeline, :as => proc { |m| m.timeline.headline }
    indexes :user, :as => proc { |m| m.user.name }
  end

  validates :asset_caption, :asset_credit, :headline, :length => {:maximum => 255}
  validates :headline, :presence => true
  validates :startdate, :date => { :allow_future => true }, :presence => true
  validates :enddate, :date => {:allow_future => true}, :allow_blank => true
  validates :timeline_id, :user_id, :numericality => {:is_integer => true}, :presence => true

  belongs_to :timeline
  belongs_to :user

  private

    before_save do |moment|
      moment.enddate = startdate if enddate.blank?
    end
end
