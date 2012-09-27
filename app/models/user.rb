class User < ActiveRecord::Base
  rolify

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :verified_at, :provider, :uid, :phone, :bio, :bio_markdown, :volunteer_attributes, :staff_attributes

  validates :name, :bio_markdown, :presence => true
  validates :phone, :length => { :minimum => 7, :maximum => 20 }, :phone => true, :allow_blank => true

  has_many :pages
  has_many :revisions, :foreign_key => :author_id
  has_one :volunteer, :dependent => :destroy
  has_one :staff, :dependent => :destroy

  accepts_nested_attributes_for :volunteer
  accepts_nested_attributes_for :staff

  before_save :do_before_save

  def remove_staff
    staff.destroy
  end

  def remove_volunteer
    volunteer.destroy
  end

  def staff?
    staff
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
    volunteer
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
    end

end
