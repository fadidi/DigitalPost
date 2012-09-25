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
  
  it "should create a new instance given a valid attribute" do
    User.create!(@attr)
  end

  describe 'properties' do
    it 'should have a bio attribute' do
      User.new(@attr).should respond_to :bio
    end

    it 'should have a bio_markdown attribute' do
      User.new(@attr).should respond_to :bio_markdown
    end

    it "should have an encrypted password attribute" do
      User.new(@attr).should respond_to(:encrypted_password)
    end

    it {should respond_to :name }

    it "should have a password attribute" do
      User.new(@attr).should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      User.new(@attr).should respond_to(:password_confirmation)
    end

    it {should respond_to :phone }

    it 'should have a provider attribute' do
      User.new(@attr).should respond_to :provider
    end

    it 'should respond to verified_at' do
      User.new(@attr).should respond_to :verified_at
    end

    it 'should have a provider attribute' do
      User.new(@attr).should respond_to :uid
    end

    describe 'bio' do
      it 'should be blank by default' do
        User.new(@attr).bio.should be_blank
      end

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
      it 'should not be blank by default' do
        User.new(@attr).bio_markdown.should_not be_blank
      end
    end

    describe "password encryption" do
      before(:each) do
        @user = User.create!(@attr)
      end
      
      it "should set the encrypted password attribute" do
        @user.encrypted_password.should_not be_blank
      end
    end

    describe 'phone' do
      it { User.new(@attr.merge(:phone => '')).should be_valid }
    end

    describe 'verified_at' do
      before :each do
        @user = FactoryGirl.create :user
      end

      it 'should be false by default' do
        @user.verified_at.should be_false
      end
    end
  end

  describe 'methods' do
    before :each do
      @user = FactoryGirl.create :user
    end

    it 'should respond to verified?' do
      @user.should respond_to :verified?
    end

    it 'should respond to verify' do
      @user.should respond_to :verify
    end

    describe 'to_param' do
      it 'should use id-name' do
        @user.to_param.should eq "#{@user.id}-#{@user.name.parameterize}"
      end
    end

    describe 'verified?' do
      before :each do
        @user = FactoryGirl.create :user
      end

      it 'should be false by default' do
        @user.verified?.should be_false
      end

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

          it 'should add default role if no roles are set' do
            @valid_email = FactoryGirl.create(:valid_email, :email => @user.email)
            @role = @valid_email.permissions.split(',')
            @user.verify
            @user.has_role?(@role[0]).should be_true
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
  end
  
  describe 'validations' do
    describe 'bio' do
      it 'should always be valid' do
        User.new(@attr.merge(:bio => '')).should be_valid
      end
    end

    describe 'bio_markdown' do
      it 'should require a bio_markdown' do
        User.new(@attr.merge(:bio_markdown => '')).should_not be_valid
      end
    end

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
    
    describe "password validations" do
      it "should require a password" do
        User.new(@attr.merge(:password => "", :password_confirmation => "")).
          should_not be_valid
      end

      it "should require a matching password confirmation" do
        User.new(@attr.merge(:password_confirmation => "invalid")).
          should_not be_valid
      end
      
      it "should reject short passwords" do
        short = "a" * 5
        hash = @attr.merge(:password => short, :password_confirmation => short)
        User.new(hash).should_not be_valid
      end
    end

    describe 'phone' do
      it 'should reject phone numbers longer than 20 chars' do
        long = '1' * 21
        User.new(@attr.merge(:phone => long)).should_not be_valid
      end

      it 'should reject phone numbers shorter than 7 chars' do
        short = '1' * 6
        User.new(@attr.merge(:phone => short)).should_not be_valid
      end

      it 'should allow numbers, -, ., +, and spaces' do
        good_numbers = ['+221773304831', '221 77 330 48 31', '221.77.330.4831', '221-77-330-4831']
        good_numbers.each { |num| User.new(@attr.merge(:phone => num)).should be_valid }
      end

      it 'should reject characters other than numbers, -, ., +, and spaces' do
        bad_numbers = ['1509869e498', ' 345,23535654654', '57393850/38302']
        bad_numbers.each { |num| User.new(@attr.merge(:phone => num)).should_not be_valid }
      end
    end
  end

  describe 'associations' do
    before :each do
      @user = FactoryGirl.create :user
    end

    it 'should respond to revisions' do
      @user.should respond_to :revisions
    end

    context 'revisions' do
      before :each do
        @revision = FactoryGirl.create(:revision, :author => @user)
      end

      it 'should have the correct revisions' do
        @user.revisions.should eq [@revision]
      end
    end
  end

  describe 'abilities' do
    context 'guest' do
      before :each do
        @ability = Ability.new(User.new)
      end

      describe 'pages' do
        it 'should read' do
          @ability.should be_able_to :read, Page
        end

        it 'should not create' do
          @ability.should_not be_able_to :create, Page
        end
      end
    end

    context 'user' do
      before :each do
        @ability = Ability.new(@user = FactoryGirl.create(:user))
      end

      describe 'users' do
        it "should be able to read its own profile" do
          @ability.should be_able_to :read, @user
        end
        
        it 'should not be able to read random profiles' do
          @user2 = FactoryGirl.create :user
          @ability.should_not be_able_to :read, @user2
        end
      end
    end
  end
end
