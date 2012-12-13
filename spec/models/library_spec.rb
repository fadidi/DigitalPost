require 'spec_helper'

describe Library do
  before :each do
    @attr = {
      :name => 'test'
  }
  end

  it {Library.create! @attr}

  # attributes
  it {should respond_to :description}
  it {should respond_to :name}
  it {should respond_to :owner_id}
  it {should respond_to :photo}
  it {should respond_to :restricted}

  # associations
  it {should respond_to :contributors}
  it {should respond_to :owner}
  it {should respond_to :stacks}

  # methods
  it {should respond_to :owner?}
  it {should respond_to :restricted?}
  it {should respond_to :to_param}

  # carrierwave
  it {should respond_to :photo?}

  describe 'properties' do
    it {Library.new.description.should be_blank}
    it {Library.new.name.should be_blank}
    it {Library.new.official.should be_false}
    it {Library.new.owner_id.should be_blank}
    it {Library.new.photo.should be_blank}
    it {Library.new.restricted.should be_false}
    it {Library.new.shared.should be_false}
  end

  describe 'validations' do
    it {Library.new(@attr.merge(:description => '')).should be_valid}
    it {Library.new(@attr.merge(:name => '')).should_not be_valid}
    it {Library.new(@attr.merge(:name => 'a'*256)).should_not be_valid}
    it {Library.new(@attr.merge(:official => '')).should be_valid}
    it {Library.new(@attr.merge(:owner_id => '')).should be_valid}
    it {Library.new(@attr.merge(:owner_id => 'a')).should_not be_valid}
    it {Library.new(@attr.merge(:photo => '')).should be_valid}
    it {Library.new(@attr.merge(:restricted => '')).should be_valid}
    it {Library.new(@attr.merge(:shared => '')).should be_valid}
  end

  describe 'associations' do
    describe 'contributors' do
      before :each do
        FactoryGirl.create(:stack, :user => @user = FactoryGirl.create(:user), :library => @lib = FactoryGirl.create(:library))
      end

      it 'should be a user' do
        @lib.contributors.first.should be_a_kind_of User
      end

      it 'should be the correct user' do
        FactoryGirl.create(:user)
        @lib.contributors.should eq [@user]
      end

      it { expect {
        @lib.destroy
      }.to change(User, :count).by(0)}
    end

    describe 'stacks' do
      before :each do
        @stack = FactoryGirl.create(:stack, :library => @lib = FactoryGirl.create(:library))
      end

      it 'should be a stack' do
        @lib.stacks.first.should be_a_kind_of Stack
      end

      it 'should be the correct stack' do
        FactoryGirl.create(:stack)
        @lib.stacks.should eq [@stack]
      end

      it { expect {
        @lib.destroy
      }.to change(Stack, :count).by(-1)}
    end

    describe 'owner' do
      before :each do
        @lib = FactoryGirl.create(:library, :owner => @user = FactoryGirl.create(:user))
      end

      it 'should be a User' do
        @lib.owner.should be_a_kind_of User
      end

      it 'should be the correct user' do
        FactoryGirl.create :user
        @lib.owner.should eq @user
      end

      it { expect {
        @lib.destroy
      }.to change(User, :count).by(0)}
    end
  end

  describe 'methods' do
    describe 'documents' do
      before :each do
        FactoryGirl.create(:stack, :library => @lib = FactoryGirl.create(:library), :stackable => @stackable = FactoryGirl.create(:document))
      end

      it 'should be a document' do
        @lib.documents.first.should be_a_kind_of Document
      end

      it 'should be the correct document' do
        FactoryGirl.create(:document)
        @lib.documents.should eq [@stackable]
      end

      it { expect {
        @lib.destroy
      }.to change(Document, :count).by(0)}
    end

    describe 'official?' do
      it {Library.new.official?.should be_false}
      it {Library.new(@attr.merge(:official => true)).official?.should be_true}
    end

    describe 'owner?' do
      it {Library.new.owner?.should_not be_true}

      it 'should be true with an owner assigned' do
        FactoryGirl.create(:library, :owner => FactoryGirl.create(:user)).owner?.should be_true
      end
    end

    describe 'restricted?' do
      it {Library.new.restricted?.should be_false}
      it {Library.new(@attr.merge(:restricted => true)).restricted?.should be_true}
    end

    describe 'shared?' do
      it {Library.new.shared?.should be_false}
      it {Library.new(@attr.merge(:shared => true)).shared?.should be_true}
    end

    describe 'to_param' do
      it 'should set name in to_param' do
        @lib = FactoryGirl.create(:library)
        @lib.to_param.should eq "#{@lib.id}-#{@lib.name.parameterize}"
      end
    end
  end

  describe 'scopes' do
    describe 'default' do
      it 'should order by name' do
        @liba = FactoryGirl.create(:library, :name => 'Aaa')
        @libc = FactoryGirl.create(:library, :name => 'Ccc')
        @libb = FactoryGirl.create(:library, :name => 'Bbb')
        Library.all.should eq [@liba,@libb,@libc]
      end
    end
  end
end
