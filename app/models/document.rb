class Document < ActiveRecord::Base
  attr_accessible :author, :description, :file, :file_content_type, :file_file_size, :file_hash, :language_id, :photo, :remove_file, :remove_photo, :remove_source, :restricted, :source, :source_content_type, :source_file_size, :title, :user_id

  # elasticsearch indexing
  include Tire::Model::Search
  include Tire::Model::Callbacks
  index_name ELASTICSEARCH_INDEX
  mapping do
    indexes :handle, :as => 'title'
    indexes :author
    indexes :description
    indexes :file
    indexes :language, :as => proc { |d| d.language.name }
    indexes :restricted
    indexes :source
    indexes :title
    indexes :user, :as => proc { |d| d.user.name }
  end

  mount_uploader :file, DocumentUploader
  mount_uploader :photo, PhotoUploader
  mount_uploader :source, DocumentUploader

  validates :author, :length => { :maximum => 255 }
  validates :file, :presence => true
  validates :language_id, :user_id, :presence => true, :numericality => { :is_integer => true }
  validates :photo,
    :file_size => {
      :maximum => 10.megabytes.to_i
    }
  validates :title, :presence => true, :length => { :maximum => 255 }

  belongs_to :language
  belongs_to :user

  default_scope :order => 'id DESC'

  def to_param
    "#{id}-#{title.parameterize}"
  end

  private

    before_validation do |this_doc|
      this_doc.title = file.file.original_filename if title.blank? && !file.blank?
    end
end
