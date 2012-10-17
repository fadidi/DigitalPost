class Timeline < ActiveRecord::Base
  attr_accessible :asset_caption, :asset_credit, :asset_media, :headline, :startdate, :text, :ttype

  validates :asset_caption, :asset_credit, :ttype, :length => {:maximum => 255}
  validates :headline, :uniqueness => {:case_sensitive => false}
  validates :headline, :length => {:maximum => 255}, :presence => true
  validates :startdate, :date => { :allow_future => true }
end
