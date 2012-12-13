require 'spec_helper'

describe Stack do
  before :each do
  	@attr = {
  	  :library_id => FactoryGirl.create(:library).id,
  	  :stackable_id => FactoryGirl.create(:document).id,
  	  :stackable_type => 'Document',
  	  :user_id => 1
  	}
  end

  it {Stack.create! @attr}

  # attributes
  it {should respond_to :library_id}
  it {should respond_to :stackable_id}
  it {should respond_to :stackable_type}
  it {should respond_to :user_id}

  # associations
  it {should respond_to :library}
  it {should respond_to :stackable}
  it {should respond_to :user}

  # methods
  it {should respond_to :to_param}

  describe 'properties' do
  	it {Stack.new.library_id.should be_blank}
  	it {Stack.new.stackable_id.should be_blank}
  	it {Stack.new.stackable_type.should be_blank}
  	it {Stack.new.user_id.should be_blank}
  end

  describe 'validations' do
  	it {Stack.new(@attr.merge(:library_id => '')).should_not be_valid}
  	it {Stack.new(@attr.merge(:library_id => 'a')).should_not be_valid}
  	it {Stack.new(@attr.merge(:stackable_id => '')).should_not be_valid}
  	it {Stack.new(@attr.merge(:stackable_id => 'a')).should_not be_valid}
  	it {Stack.new(@attr.merge(:stackable_type => '')).should_not be_valid}
  	it {Stack.new(@attr.merge(:stackable_type => 'a'*256)).should_not be_valid}
  	it {Stack.new(@attr.merge(:user_id => '')).should_not be_valid}
  	it {Stack.new(@attr.merge(:user_id => 'a')).should_not be_valid}
  end

  describe 'associations' do
  	describe 'library' do
  		before :each do
  			@stack = FactoryGirl.create(:stack, :library => @library = FactoryGirl.create(:library))
  		end

  		it 'should be a library' do
  			@stack.library.should be_a_kind_of Library
  		end

  		it 'should be the right library' do
  			@stack.library.should eq @library
  		end

  		it { expect {
  			@stack.destroy
  		}.to change(Library, :count).by(0)}
  	end

  	[ Document, CaseStudy, Photo ].each do |resource|
  		describe 'stackable' do
	  		before :each do
	  			@stack = FactoryGirl.create(:stack, :stackable => @resource = FactoryGirl.create(resource.to_s.underscore.to_sym))
	  		end

	  		it "should be a/n #{resource.to_s}" do
	  			@stack.stackable.should be_a_kind_of resource
	  		end

	  		it "should be the right #{resource.to_s}" do
	  			@stack.stackable.should eq @resource
	  		end

	  		it { expect {
	  			@stack.destroy
	  		}.to change(resource, :count).by(0)}
	  	end
	  end

  	describe 'user' do
  		before :each do
  			@stack = FactoryGirl.create(:stack, :user => @user = FactoryGirl.create(:user))
  		end

  		it 'should be a user' do
  			@stack.user.should be_a_kind_of User
  		end

  		it 'should be the right library' do
  			@stack.user.should eq @user
  		end

  		it { expect {
  			@stack.destroy
  		}.to change(User, :count).by(0)}
  	end
  end
end
