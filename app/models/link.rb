class Link < ActiveRecord::Base
  attr_accessible :description, :language_id, :name, :url, :user_id

  # elasticsearch indexing
  include Tire::Model::Search
  include Tire::Model::Callbacks
  index_name ELASTICSEARCH_INDEX
  mapping do
    indexes :handle, :as => 'name'
    indexes :description
    indexes :name
    indexes :url
  end

  validates :language_id, :user_id, :numericality => {:is_integer => true}
  validates :url, :url => true, :uniqueness => {:case_sensitive => false}
  validates :description, :length => {:maximum => 255}, :allow_blank => true

  belongs_to :language
  belongs_to :user

  def title
    if !name.blank?
      name
    elsif !url.blank?
      url
    else
      ''
    end
  end

  def to_param
    name.blank? ? id : "#{id}-#{name.parameterize}"
  end
end
