require 'spec_helper'
require 'cancan/matchers'

describe User do
  
  before(:each) do
    @attr = { 
      :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end
  
  it {User.create! @attr}

  # properties
  it {should respond_to :bio}
  it {should respond_to :bio_markdown}
  it {should respond_to :blog_title}
  it {should respond_to :blog_url}
  it {should respond_to(:encrypted_password)}
  it {should respond_to :name }
  it {should respond_to(:password)}
  it {should respond_to(:password_confirmation)}
  it {should respond_to :phone }
  it {should respond_to :provider}
  it {should respond_to :uid}
  it {should respond_to :verified_at}
  it {should respond_to :website}

  # methods
  it {should respond_to :fname}
  it {should respond_to :staff?}
  it {should respond_to :to_param}
  it {should respond_to :verified?}
  it {should respond_to :verify}
  it {should respond_to :volunteer?}
  it {should respond_to :remove_staff}
  it {should respond_to :remove_volunteer}

  #associations
  it {should respond_to :pages}
  it {should respond_to :revisions}
  it {should respond_to :staff}
  it {should respond_to :volunteer}

  describe 'properties' do
    describe 'bio' do
      it {User.new(@attr).bio.should be_blank}

      it 'should be populated before save' do
        @user = User.new(@attr)
        @user.save!
        @user.bio.should_not be_blank
      end

      it 'should update bio based on bio_markdown' do
        @user = FactoryGirl.create :user
        @user.update_attributes(:bio_markdown => 'new cool content')
        @user.bio.should =~ /new cool content/i
      end
    end

    describe 'bio_markdown' do
      it {User.new(@attr).bio_markdown.should_not be_blank}
    end

    it {User.new.blog_title.should be_blank}
    it {User.new.blog_title.should be_blank}

    describe "password encryption" do
      before(:each) do
        @user = User.create!(@attr)
      end
      
      it {@user.encrypted_password.should_not be_blank}
    end

    describe 'phone' do
      it { User.new(@attr.merge(:phone => '')).should be_valid }
    end

    describe 'verified_at' do
      it {User.new(@attr).verified_at.should be_false}
    end

    it {User.new.website.should be_blank}
  end

  describe 'methods' do
    before :each do
      @user = FactoryGirl.create :user
    end

    describe 'fname' do
      it 'should retrieve name up to a whitespace' do
        @user.name = 'Jack Brown'
        @user.fname.should =~ /^jack$/i
      end

      it 'sholud return full name without whitespace' do
        @user.name = 'JackBrown'
        @user.fname.should =~ /jackbrown/i
      end
    end

    describe 'remove_staff' do
      it 'should destroy an associated volunteer' do
        FactoryGirl.create(:staff, :user => @user)
        expect {
          @user.remove_staff
        }.to change(Staff, :count).by(-1)
      end
    end

    describe 'remove_volunteer' do
      it 'should destroy an associated volunteer' do
        FactoryGirl.create(:volunteer, :user => @user)
        expect {
          @user.remove_volunteer
        }.to change(Volunteer, :count).by(-1)
      end
    end

    describe 'staff?' do
      it 'should be true if there is a staff record' do
        FactoryGirl.create(:staff, :user => @user)
        @user.staff?.should be_true
      end

      it 'should be false without a volunteer' do
        @user.staff?.should_not be_true
      end
    end
  
    describe 'to_param' do
      it 'should use id-name' do
        @user.to_param.should eq "#{@user.id}-#{@user.name.parameterize}"
      end
    end

    describe 'verified?' do
      it {@user.verified?.should be_false}

      it 'should be true after verification' do
        @user.verify
        @user.verified?.should be_true
      end
    end

    describe 'verify' do
      it 'should set verified = true' do
        @user.verify
        @user.reload
        @user.verified?.should be_true
      end

      it 'should set verified_at to Time.now' do
        time = Time.now - 1.second
        @user.verify
        @user.reload
        @user.verified_at.should be > time
      end

      context 'without ValidEmail' do
        it 'should not add any roles' do
          count = @user.roles.count
          @user.verify
          @user.roles.count.should eq count
        end
      end

      context 'with ValidEmail' do
        describe 'which is not expired' do
          it 'should set verified? = true' do
            @valid_email = FactoryGirl.create(:valid_email, :email => @user.email)
            @user.verify
            @user.reload
            @user.verified?.should be_true
          end

          it 'should set no roles if no valid_email record' do
            @user.verify
            @user.roles.any?.should_not be_true
            @user.volunteer?.should_not be_true
          end

          it 'should add default role if no roles are set' do
            @valid_email = FactoryGirl.create(:valid_email, :email => @user.email)
            @role = @valid_email.permissions.split(',')
            @user.verify
            @user.has_role?(@role[0]).should be_true
          end

          it 'should not remove roles after deletion of valid_email' do
            @valid_email = FactoryGirl.create(:valid_email, :email => @user.email)
            @user.verify
            roles = @user.roles
            @valid_email.destroy
            @user.verify
            @user.roles.should eq roles
          end

          it 'should add any roles set in ValidEmail' do
            permissions = ['user','staff']
            @valid_email = FactoryGirl.create(:valid_email, :email => @user.email, :permissions => permissions.join(','))
            @user.verify
            @user.has_all_roles? {permissions}.should be_true
          end

          it 'should remove any extra permissions' do
            extra_roles = ['a','b','c','d']
            @valid_email = FactoryGirl.create(:valid_email, :email => @user.email, :permissions => extra_roles.join(','))
            @user.verify
            @valid_email.update_attributes(:permissions => 'nobleman,knight')
            @user.verify
            extra_roles.each do |role|
              @user.has_role?(role).should be_false
            end
            @user.roles.count.should eq @valid_email.permissions.split(',').count
          end

          context 'staff role' do
            before :each do
              @valid_email = FactoryGirl.
                create(:valid_email, :email => @user.email, :permissions => 'staff')
            end

            it 'should create a staff for the user' do
              @user.staff?.should_not be_true
              @user.verify
              @user.staff?.should be_true
            end

            it 'should not remove staff on role removal' do
              @user.verify
              @valid_email.update_attributes(:permissions => 'knight')
              @user.verify
              @user.reload
              @user.staff?.should be_true
            end
          end

          context 'volunteer role' do
            before :each do
              @valid_email = FactoryGirl.
                create(:valid_email, :email => @user.email, :permissions => 'volunteer')
            end

            it 'should create a volunteer for the user' do
              @user.volunteer?.should_not be_true
              @user.verify
              @user.volunteer?.should be_true
            end

            it 'should not remove volunteer on role removal' do
              @user.verify
              @valid_email.update_attributes(:permissions => 'knight')
              @user.verify
              @user.reload
              @user.volunteer?.should be_true
            end
          end
        end

        describe 'which is expired' do
          it 'should set verified? = true' do
            @valid_email = FactoryGirl.create(:valid_email, :email => @user.email, :expires_at => Time.now - 1.day)
            @user.verify
            @user.reload
            @user.verified?.should be_true
          end

          it 'should remove all roles from user' do
            roles = ['knight','pawn','rook']
            @valid_email = FactoryGirl.create(:valid_email, :email => @user.email, :permissions => roles.join(','))
            @user.verify
            @valid_email.update_attributes(:expires_at => Time.now - 1.day)
            @user.verify
            roles.each { |role| @user.has_role?(role).should be_false }
          end
        end
      end
    end

    describe 'volunteer?' do
      it 'should be true if there is a volunteer record' do
        FactoryGirl.create(:volunteer, :user => @user)
        @user.volunteer?.should be_true
      end

      it 'should be false without a volunteer' do
        @user.volunteer?.should_not be_true
      end
    end
  end
  
  describe 'validations' do
    describe 'bio' do
      it 'should always be valid' do
        User.new(@attr.merge(:bio => '')).should be_valid
      end
    end

    describe 'bio_markdown' do
      it {User.new(@attr.merge(:bio_markdown => '')).should_not be_valid}
    end

    describe 'blog_title' do
      it {User.new(@attr.merge(:blog_title => '')).should be_valid}
      it {User.new(@attr.merge(:blog_title => 'a'*256)).should_not be_valid}
    end

    describe 'blog_url' do
      it {User.new(@attr.merge(:blog_url => '')).should be_valid}
      it {User.new(@attr.merge(:blog_url => 'a'*256)).should_not be_valid}

      it 'should allow valid hyperlinks' do
        ['http://www.example.com', 'https://www.example.com', 'http://example.com', 'http://example.com/test.html', 'http://example.com/test', 'http://example.com/?q=test', 'http://example.com?q=test', 'http://example.com/test/?q=test'].
          each { |good_url| User.new(@attr.merge(:blog_url => good_url)).should be_valid }
      end

      it 'should reject non-valid hyperlinks' do
        ['www.example.com', 'example.com', 'http/www.example.com', 'http:/www.example.com', 'this is not a link', 'http://www.example.com/this is invalid'].
          each { |bad_url| User.new(@attr.merge(:blog_url => bad_url)).should_not be_valid }
      end
    end

    describe 'email' do
      it "should require an email address" do
        no_email_user = User.new(@attr.merge(:email => ""))
        no_email_user.should_not be_valid
      end
      
      it "should accept valid email addresses" do
        addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
        addresses.each do |address|
          valid_email_user = User.new(@attr.merge(:email => address))
          valid_email_user.should be_valid
        end
      end
      
      it "should reject invalid email addresses" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
        addresses.each do |address|
          invalid_email_user = User.new(@attr.merge(:email => address))
          invalid_email_user.should_not be_valid
        end
      end
      
      it "should reject duplicate email addresses" do
        User.create!(@attr)
        user_with_duplicate_email = User.new(@attr)
        user_with_duplicate_email.should_not be_valid
      end
      
      it "should reject email addresses identical up to case" do
        upcased_email = @attr[:email].upcase
        User.create!(@attr.merge(:email => upcased_email))
        user_with_duplicate_email = User.new(@attr)
        user_with_duplicate_email.should_not be_valid
      end
    end

    describe 'name' do
      it {User.new(@attr.merge(:name => '')).should_not be_valid}
      it {User.new(@attr.merge(:name => 'a'*7)).should_not be_valid}
      it {User.new(@attr.merge(:name => 'a'*256)).should_not be_valid}

      it 'should reject duplicate names up to case' do
        @user = FactoryGirl.create :user
        User.new(@attr.merge(:name => @user.name.upcase)).should_not be_valid
      end
    end
    
    describe "password validations" do
      it "should require a password" do
        User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
      end

      it "should require a matching password confirmation" do
        User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
      end
      
      it "should reject short passwords" do
        User.new(@attr.merge(:password => 'a'*5, :password_confirmation => 'a'*5)).should_not be_valid
      end
    end

    describe 'phone' do
      it 'should reject phone numbers longer than 20 chars' do
        User.new(@attr.merge(:phone => '1'*21)).should_not be_valid
      end

      it 'should reject phone numbers shorter than 7 chars' do
        User.new(@attr.merge(:phone => '1'*6)).should_not be_valid
      end

      it 'should allow numbers, -, ., +, and spaces' do
        ['+221773304831', '221 77 330 48 31', '221.77.330.4831', '221-77-330-4831'].each { |num| User.new(@attr.merge(:phone => num)).should be_valid }
      end

      it 'should reject characters other than numbers, -, ., +, and spaces' do
        ['1509869e498', ' 345,23535654654', '57393850/38302'].each { |num| User.new(@attr.merge(:phone => num)).should_not be_valid }
      end
    end

    describe 'website' do
      it {User.new(@attr.merge(:website => '')).should be_valid}
      it {User.new(@attr.merge(:website => 'a'*256)).should_not be_valid}

      it 'should allow valid hyperlinks' do
        ['http://www.example.com', 'https://www.example.com', 'http://example.com', 'http://example.com/test.html', 'http://example.com/test', 'http://example.com/?q=test', 'http://example.com?q=test', 'http://example.com/test/?q=test'].
          each { |good_url| User.new(@attr.merge(:website => good_url)).should be_valid }
      end

      it 'should reject non-valid hyperlinks' do
        ['www.example.com', 'example.com', 'http/www.example.com', 'http:/www.example.com', 'this is not a link', 'http://www.example.com/this is invalid'].
          each { |bad_url| User.new(@attr.merge(:website => bad_url)).should_not be_valid }
      end
    end
  end

  describe 'associations' do
    before :each do
      @user = FactoryGirl.create :user
    end

    describe 'pages' do
      before :each do
        @page = FactoryGirl.create(:page, :user => @user)
      end

      it 'should be a page' do
        @user.pages.first.should be_an_instance_of Page
      end

      it 'should have the correct pages' do
        FactoryGirl.create :page
        @user.pages.should eq [@page]
      end
    end

    describe 'revisions' do
      before :each do
        @revision = FactoryGirl.create(:revision, :author => @user)
      end

      it 'should have the correct revisions' do
        @user.revisions.should eq [@revision]
      end
    end

    describe 'staff' do
      before :each do
        @staff = FactoryGirl.create(:staff, :user => @user)
      end

      it 'should accept nested attributes' do
        @user.update_attributes(:staff_attributes => {:location => 'dakar'})
        @staff = Staff.find_by_user_id(@user.id)
        @staff.location.should =~ /dakar/i
      end

      it 'should be a staff' do
        @user.staff.should be_an_instance_of Staff
      end

      it 'should be the right staff' do
        FactoryGirl.create :staff
        @user.staff.should eq @staff
      end

      it 'should destroy the staff on destroy' do
        expect {
          @user.destroy
        }.to change(Staff, :count).by(-1)
      end
    end

    describe 'volunteer' do
      before :each do
        @vol = FactoryGirl.create(:volunteer, :user => @user)
      end

      it 'should accept nested attributes' do
        @user.update_attributes(:volunteer_attributes => {:local_name => 'babakar'})
        @vol = Volunteer.find_by_user_id(@user.id)
        @vol.local_name.should =~ /babakar/i
      end

      it 'should be a volunteer' do
        @user.volunteer.should be_an_instance_of Volunteer
      end

      it 'should be the right volunteer' do
        FactoryGirl.create :volunteer
        @user.volunteer.should eq @vol
      end

      it 'should destroy the volunteer on destroy' do
        expect {
          @user.destroy
        }.to change(Volunteer, :count).by(-1)
      end
    end
  end

  describe 'abilities' do
    context 'guest' do
      before :each do
        @ability = Ability.new(User.new)
      end

      it 'should read correctly' do
        [Page].
          each { |resource| @ability.should be_able_to :read, resource }
        [Ability, Reference, Revision, Role, @user, ValidEmail, Volunteer].
          each { |resource| @ability.should_not be_able_to :read, resource }
      end

      it 'should create, edit, destroy correctly' do
        [Ability, Page, Reference, Revision, Role, User, ValidEmail, Volunteer].
          each { |resource| @ability.should_not be_able_to [:create, :edit, :destroy], resource }
      end
    end

    context 'volunteer/staff' do
      before :each do
        @vol = FactoryGirl.create(:user)
        @vol.add_role(:volunteer)
        @staff = FactoryGirl.create(:user)
        @staff.add_role(:staff)
      end

      it 'should read correctly' do
        [@vol, @staff].each do |user|
          @ability = Ability.new(user)
          [Page, Reference, Revision, User, Volunteer].
            each { |resource| @ability.should be_able_to :read, resource }
          [Ability, Role, ValidEmail].
            each { |resource| @ability.should_not be_able_to :read, resource }
        end
      end

      it 'should create correctly' do
        [@vol, @staff].each do |user|
          @ability = Ability.new(user)
          [Page, Revision].
            each { |resource| @ability.should be_able_to :create, resource }
        end
      end
    end

    context 'moderator' do
      before :each do
        @user = FactoryGirl.create(:user)
        @user.add_role(:moderator)
        @ability = Ability.new(@user)
      end

      it 'should manage correctly' do
        [Page, Revision, Role, ValidEmail].
          each { |resource| @ability.should be_able_to :manage, resource }
      end
    end

    context 'admin' do
      before :each do
        @user = FactoryGirl.create(:user)
        @user.add_role(:admin)
        @ability = Ability.new(@user)
      end

      it 'should manage everything' do
        [Ability, Page, Reference, Revision, Role, User, ValidEmail, Volunteer].
          each { |resource| @ability.should be_able_to :manage, resource }
      end
    end
  end
end
