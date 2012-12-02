require 'spec_helper'

describe Unit do
  before :each do
    @attr = {
      :name => 'Test Unit'
    }
  end

  it {Unit.create! @attr}

  # properties
  it {should respond_to :photo}
  it {should respond_to :photo_content_type}
  it {should respond_to :photo_file_size}
  it {should respond_to :photo_hash}
  it {should respond_to :name}
  it {should respond_to :description}
  it {should respond_to :head_id}

  #associations
  it {should respond_to :head}
  it {should respond_to :staff}
  it {should respond_to :users}

  # methods
  it {should respond_to :head?}
  it {should respond_to :to_param}

  # carrierwave
  it {should respond_to :photo?}
  it {should respond_to :remove_photo}
  it {should respond_to :remove_photo!}

  describe 'properties' do
    it {Unit.new.name.should be_blank}
    it {Unit.new.description.should be_blank}
    it {Unit.new.head_id.should be_blank}
    it {Unit.new.photo.should be_blank}

    describe 'photo_content_type' do
      it {Unit.new.photo_content_type.should be_blank}

      it 'should populate on successful attachment' do
        @unit = FactoryGirl.create :unit
        @unit.photo = (File.open('spec/support/images/10x10.gif'))
        @unit.save!
        @unit.photo_content_type.should_not be_blank
      end
    end

    describe 'photo_file_size' do
      it {Unit.new.photo_file_size.should be_blank}

      it 'should populate on successful attachment' do
        @unit = FactoryGirl.create :unit
        @unit.photo = (File.open('spec/support/images/10x10.gif'))
        @unit.save!
        @unit.photo_file_size.should_not be_blank
      end
    end

    describe 'photo_hash' do
      it {Unit.new.photo_hash.should be_blank}

      it 'should populate on successful attachment' do
        @unit = FactoryGirl.create :unit
        @unit.photo = (File.open('spec/support/images/10x10.gif'))
        @unit.save!
        @unit.photo_hash.should_not be_blank
      end
    end
  end

  describe 'validations' do
    describe 'name' do
      it {Unit.new(@attr.merge(:name => '')).should_not be_valid}
      it {Unit.new(@attr.merge(:name => 'a'*256)).should_not be_valid}

      it 'should validate uniqueness up to case' do
        Unit.create! @attr.merge(:name => 'Test')
        Unit.new(@attr.merge(:name => 'Test'.upcase)).should_not be_valid
      end
    end

    it {Unit.new(@attr.merge(:description => '')).should be_valid}
    it {Unit.new(@attr.merge(:description => 'a'*256)).should_not be_valid}
    it {Unit.new(@attr.merge(:head_id => '')).should be_valid}
    it {Unit.new(@attr.merge(:head_id => 'a')).should_not be_valid}
    it {Unit.new(@attr.merge(:photo => '')).should be_valid}
    it {Unit.new(@attr.merge(:photo_content_type => '')).should be_valid}
    it {Unit.new(@attr.merge(:photo_file_size => '')).should be_valid}
    it {Unit.new(@attr.merge(:photo_file_size => 'a')).should_not be_valid}

    describe 'photo_hash' do
      it {Unit.new(@attr.merge(:photo_hash => '')).should be_valid}

      it 'should not allow duplicates' do
        Unit.create!(@attr.merge(:photo_hash => 'test'))
        Unit.new(@attr.merge(:photo_hash => 'test')).should_not be_valid
      end
    end
  end

  describe 'associations' do
    describe 'head' do
      before :each do
        @unit = FactoryGirl.create(:unit, :head => @staff = FactoryGirl.create(:staff))
      end

      it 'should be a Staff' do
        @unit.head.should be_a_kind_of Staff
      end

      it 'should be the correct staff' do
        FactoryGirl.create :staff
        @unit.head.should eq @staff
      end

      it { expect {
        @unit.destroy
      }.to change(Staff, :count).by(0)}
    end

    describe 'staff' do
      before :each do
        @staff = FactoryGirl.create(:staff, :unit => @unit = FactoryGirl.create(:unit))
      end

      it 'should be a Staff' do
        @unit.staff.first.should be_a_kind_of Staff
      end

      it 'should be the correct staff' do
        FactoryGirl.create :staff
        @unit.staff.should eq [@staff]
      end

      it { expect {
        @unit.destroy
      }.to change(Staff, :count).by(0)}

      it 'should nullify staff' do
        @unit.destroy
        @staff.reload
        @staff.unit_id.should be_blank
      end
    end

    describe 'users' do
      before :each do
        @staff = FactoryGirl.create(:staff, :user => @user = FactoryGirl.create(:user), :unit => @unit = FactoryGirl.create(:unit))
      end

      it 'should be a User' do
        @unit.users.first.should be_a_kind_of User
      end

      it 'should be the correct user' do
        FactoryGirl.create :staff
        @unit.users.should eq [@user]
      end

      it { expect {
        @unit.destroy
      }.to change(User, :count).by(0)}
    end
  end

  describe 'methods' do
    describe 'head?' do
      it {Unit.new.head?.should_not be_true}

      it 'should be true with a unit assigned' do
        FactoryGirl.create(:unit, :head => FactoryGirl.create(:staff)).head?.should be_true
      end
    end

    describe 'to_param' do
      it 'should include the unit name' do
        @unit = FactoryGirl.create(:unit)
        @unit.to_param.should eq "#{@unit.id}-#{@unit.name.parameterize}"
      end
    end
  end

  describe 'scopes' do
    describe 'default' do
      it 'should order by name' do
        @unita = FactoryGirl.create(:unit, :name => 'Aaa')
        @unitc = FactoryGirl.create(:unit, :name => 'Ccc')
        @unitb = FactoryGirl.create(:unit, :name => 'Bbb')
        Unit.all.should eq [@unita,@unitb,@unitc]
      end
    end
  end
end
