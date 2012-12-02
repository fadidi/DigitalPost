require 'spec_helper'

describe Library do
  before :each do
    @attr = {
      :name => 'test',
      :owner_id => 1
  }
  end

  it {Library.create! @attr}

  # properties
  it {should respond_to :description}
  it {should respond_to :name}
  it {should respond_to :owner_id}

  # associations
  it {should respond_to :owner}

  # methods
  it {should respond_to :owner?}

  describe 'properties' do
    it {Library.new.description.should be_blank}
    it {Library.new.name.should be_blank}
    it {Library.new.owner_id.should be_blank}
  end

  describe 'validations' do
    it {Library.new(@attr.merge(:description => '')).should be_valid}
    it {Library.new(@attr.merge(:name => '')).should_not be_valid}
    it {Library.new(@attr.merge(:name => 'a'*256)).should_not be_valid}
    it {Library.new(@attr.merge(:owner_id => '')).should_not be_valid}
    it {Library.new(@attr.merge(:owner_id => 'a')).should_not be_valid}
  end

  describe 'associations' do
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
