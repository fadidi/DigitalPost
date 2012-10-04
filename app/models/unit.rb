class Unit < ActiveRecord::Base
  attr_accessible :avatar, :avatar_content_type, :avatar_file_size, :description, :head_id, :name, :remove_avatar
  
  # elasticsearch indexing
  include Tire::Model::Search
  include Tire::Model::Callbacks
  index_name ELASTICSEARCH_INDEX
  mapping do
    indexes :handle, :as => 'name'
    indexes :description
    indexes :name
  end

  mount_uploader :avatar, AvatarUploader

  validates :avatar,
    :file_size => {
      :maximum => 10.megabytes.to_i
    }
  validates :avatar_file_size,
    :numericality => { :is_integer => true },
    :allow_blank => true
  validates :name,
    :presence => true,
    :length => { :maximum => 255 },
    :uniqueness => { :case_sensitive => false }
  validates :head_id,
    :numericality => { :is_integer => true },
    :allow_blank => true
  validates :description,
    :length => { :maximum => 255 },
    :allow_blank => true

  belongs_to :head, :class_name => 'Staff', :foreign_key => :head_id
  has_many :staff, :dependent => :nullify
  has_many :users, :through => :staff

  default_scope :order => 'name ASC'

  before_save :do_before_save

  def head?
    !head.nil?
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  private

    def do_before_save
      if avatar.present? && avatar_changed?
        self.avatar_content_type = avatar.file.content_type
        self.avatar_file_size = avatar.file.size
      end
    end

end
