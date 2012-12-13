class User < ActiveRecord::Base
  attr_accessible :avatar, :avatar_content_type, :avatar_file_size, :name, :email, :password, :password_confirmation, :remember_me, :verified_at, :provider, :uid, :phone, :bio, :bio_markdown, :volunteer_attributes, :staff_attributes, :blog_title, :blog_url, :website, :remve_avatar

  # elasticsearch indexing
  include Tire::Model::Search
  include Tire::Model::Callbacks
  index_name ELASTICSEARCH_INDEX
  mapping do
    indexes :handle, :as => 'name'
    indexes :email
    indexes :name
    indexes :phone
    indexes :bio
    indexes :blog_title
    indexes :blog_url
    indexes :website
    indexes :local_name, :as => proc { |u| u.volunteer.local_name if u.volunteer? }
    indexes :service_info_html, :as => proc { |u| u.volunteer.service_info_html if u.volunteer? }
    indexes :site, :as => proc { |u| u.volunteer.site if u.volunteer? }
    indexes :job_description_html, :as => proc { |u| u.staff.job_description_html if u.staff? }
    indexes :job_title, :as => proc { |u| u.staff.job_title if u.staff? }
    indexes :location, :as => proc { |u| u.staff.location if u.staff? }
  end

  rolify

  mount_uploader :avatar, AvatarUploader

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable


  validates :name, :bio_markdown, :presence => true
  validates :phone, :length => { :minimum => 7, :maximum => 20 }, :phone => true, :allow_blank => true
  validates :blog_url, :website, :length => { :maximum => 255 }, :url => true, :allow_blank => true
  validates :name, :length => { :minimum => 8, :maximum => 255 }, :uniqueness => { :case_sensitive => false }
  validates :blog_title, :length => { :maximum => 255 }

  has_many :documents, :dependent => :nullify
  has_many :libraries, :foreign_key => :owner_id, :dependent => :nullify
  has_many :links, :dependent => :nullify
  has_many :moments, :dependent => :nullify
  has_many :pages
  has_many :photos, :dependent => :nullify
  has_many :revisions, :foreign_key => :author_id
  has_many :stacks, :dependent => :nullify
  has_one :staff, :dependent => :destroy
  has_one :volunteer, :dependent => :destroy
  has_one :stage, :through => :volunteer
  has_one :work_zone, :through => :volunteer

  accepts_nested_attributes_for :volunteer
  accepts_nested_attributes_for :staff

  before_save :do_before_save
  before_destroy :do_before_destroy

  default_scope :order => 'name ASC'
  scope :with_avatar, where('avatar IS NOT NULL')

  def fname
    name[/^([^ ]+)/i,1]
  end

  def remove_staff
    staff.destroy
  end

  def remove_volunteer
    volunteer.destroy
  end

  def staff?
    !staff.nil?
  end

  def unit
    staff? ? staff.unit : nil
  end

  def unit?
    staff? ? staff.unit? : false
  end

  def verified?
    !verified_at.nil?
  end

  def verify
    valid_email = ValidEmail.find_by_email(self.email)
    unless valid_email.nil?
      user = self
      if valid_email.expired?
        expired_roles = valid_email.permissions.split(',')
        expired_roles.each { |role| user.remove_role(role) }
      else
        good_roles = valid_email.permissions.split(',')
        current_roles = []
        roles.each { |role| current_roles << role.name }
        add_roles = good_roles - current_roles
        remove_roles = current_roles - good_roles
        add_roles.each do |role|
          user.add_role(role) unless self.has_role?(role)
        end
        remove_roles.each do |role|
          user.remove_role(role)
        end
      end
      valid_email.check_in
    end
    user.create_volunteer if !self.volunteer? && self.has_role?(:volunteer)
    user.create_staff if !self.staff? && self.has_role?(:staff)
    self.update_attributes(:verified_at => Time.now)
  end

  def volunteer?
    !volunteer.nil?
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(
        name:auth.extra.raw_info.name,
        provider:auth.provider,
        uid:auth.uid,
        email:auth.info.email,
        password:Devise.friendly_token[0,20]
      )
    end
    user
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  private

    def do_before_save
      self.bio = Markdown.render(bio_markdown)

      if avatar.present? && avatar_changed?
        self.avatar_content_type = avatar.file.content_type
        self.avatar_file_size = avatar.file.size
      end
    end

    def do_before_destroy
      if pages.any?
        admin = Role.unscoped.order('id DESC').find_by_name('admin').users.first
        pages.all.each { |page| page.update_attribute(:user_id, admin.id) }
      end
    end

end
