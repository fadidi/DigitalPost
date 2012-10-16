require 'spec_helper'

describe Link do
  before :each do
    @attr = {
      :url => 'http://test.com',
      :language_id => 1,
      :user_id => 1
    }
  end

  it {Link.create! @attr}

  # properties
  it {should respond_to :description}
  it {should respond_to :language_id}
  it {should respond_to :name}
  it {should respond_to :url}
  it {should respond_to :user_id}

  # associations
  it {should respond_to :language}
  it {should respond_to :user}

  # methods
  it {should respond_to :title}
  it {should respond_to :to_param}

  describe 'properties' do
    it {Link.new.description.should be_blank}
    it {Link.new.language_id.should be_blank}
    it {Link.new.name.should be_blank}
    it {Link.new.url.should be_blank}
    it {Link.new.user_id.should be_blank}
  end

  describe 'validations' do
    it {Link.new(@attr.merge(:description => '')).should be_valid}
    it {Link.new(@attr.merge(:language_id => '')).should_not be_valid}
    it {Link.new(@attr.merge(:language_id => 'a')).should_not be_valid}
    it {Link.new(@attr.merge(:name => '')).should be_valid}
    it {Link.new(@attr.merge(:name => 'a'*256)).should be_valid}

    describe 'url' do
      it {Link.new(@attr.merge(:url => '')).should_not be_valid}
      it {Link.new(@attr.merge(:url => 'a')).should_not be_valid}
      it {Link.new(@attr.merge(:url => 'http://test')).should_not be_valid}
      it {Link.new(@attr.merge(:url => 'http://www.example.com')).should be_valid}

      it 'should not allow duplicates' do
        FactoryGirl.build(:link, :url => FactoryGirl.create(:link).url).should_not be_valid
      end
    end

    it {Link.new(@attr.merge(:user_id => '')).should_not be_valid}
    it {Link.new(@attr.merge(:user_id => 'a')).should_not be_valid}
  end

  describe 'associations' do
    describe 'language' do
      before :each do
        @link = FactoryGirl.create(:link, :language => @lang = FactoryGirl.create(:language))
      end

      it {@link.language.should be_a_kind_of Language}

      it 'should be the right language' do
        FactoryGirl.create :language
        @link.language.should eq @lang
      end

      it { expect {
        @link.destroy
      }.to change(Language, :count).by(0)}
    end

    describe 'user' do
      before :each do
        @link = FactoryGirl.create(:link, :user => @user = FactoryGirl.create(:user))
      end

      it {@link.user.should be_a_kind_of User}

      it 'should be the right user' do
        FactoryGirl.create :user
        @link.user.should eq @user
      end

      it { expect {
        @link.destroy
      }.to change(User, :count).by(0)}
    end
  end

  describe 'methods' do
    describe 'title' do
      it 'should be the name if present' do
        @link = FactoryGirl.create(:link, :name => 'test name')
        @link.title.should eq @link.name
      end

      it 'should be the url if no name' do
        @link = FactoryGirl.create(:link, :name => '')
        @link.title.should eq @link.url
      end
    end

    describe 'to_param' do
      it 'should be id-name' do
        @link = FactoryGirl.create(:link, :name => 'test link')
        @link.to_param.should eq "#{@link.id}-#{@link.name.parameterize}"
      end
    end
  end
end
