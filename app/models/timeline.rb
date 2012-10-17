class Timeline < ActiveRecord::Base
  attr_accessible :asset_caption, :asset_credit, :asset_media, :headline, :startdate, :text, :ttype

  # elasticsearch indexing
  include Tire::Model::Search
  include Tire::Model::Callbacks
  index_name ELASTICSEARCH_INDEX
  mapping do
    indexes :handle, :as => 'headline'
    indexes :asset_caption
    indexes :asset_credit
    indexes :asset_media
    indexes :headline
    indexes :startdate
    indexes :enddate
    indexes :text
  end

  validates :asset_caption, :asset_credit, :ttype, :length => {:maximum => 255}
  validates :headline, :uniqueness => {:case_sensitive => false}
  validates :headline, :length => {:maximum => 255}, :presence => true
  validates :startdate, :date => { :allow_future => true }

  has_many :moments, :dependent => :destroy
end
