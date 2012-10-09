require 'spec_helper'

describe Region do
  before :each do
    @attr = {
      :name => 'Test Region',
      :abbreviation => 'TR'
    }
  end

  it {Region.create! @attr}

  # properties
  it {should respond_to :abbreviation}
  it {should respond_to :name}
  it {should respond_to :photo}

  # associations
  it {should respond_to :users}
  it {should respond_to :volunteers}
  it {should respond_to :work_zones}

  # methods
  it {should respond_to :to_param}
  it {should respond_to :work_zones?}

  # carrierwave
  it {should respond_to :photo?}
  it {should respond_to :remove_photo}
  it {should respond_to :remove_photo!}

  describe 'properties' do
    describe 'abbreviation' do
      it {Region.new.abbreviation.should be_blank}

      it 'should upcase when saving' do
        region = Region.create(@attr.merge(:abbreviation => 'up'))
        region.abbreviation.should eq 'UP'
      end
    end

    it {Region.new.name.should be_blank}

    describe 'photo' do
      it {Region.new.photo.should be_blank}

      it 'should not be blank with attached photo' do
        @region = FactoryGirl.create :region
        @region.photo = (File.open('spec/support/images/10x10.gif'))
        @region.save!
        @region.photo.should_not be_blank
      end
    end
  end

  describe 'validations' do
    describe 'abbreviation' do
      it {Region.new(@attr.merge(:abbreviation => '')).should_not be_valid}
      it {Region.new(@attr.merge(:abbreviation => 'a')).should_not be_valid}
      it {Region.new(@attr.merge(:abbreviation => 'a'*9)).should_not be_valid}

      it 'should not allow duplicates up to case' do
        Region.create! @attr.merge(:abbreviation => 'Test')
        Region.new(@attr.merge(:abbreviation => 'Test'.upcase)).should_not be_valid
      end

      it {Region.new(@attr.merge(:photo => '')).should be_valid}
    end

    describe 'name' do
      it {Region.new(@attr.merge(:name => '')).should_not be_valid}
      it {Region.new(@attr.merge(:name => 'a'*256)).should_not be_valid}

      describe 'validate uniqueness' do
        before :each do
          Region.create! @attr.merge(:name => 'Test')
        end

        it 'should not allow duplicates' do
          FactoryGirl.build(:region, :name => 'Test'.upcase).should_not be_valid
        end
      end
    end
  end

  describe 'associations' do
    describe 'users' do
      before :each do
        FactoryGirl.create(:volunteer, 
                           :work_zone => FactoryGirl.create(:work_zone, 
                                                            :region => @region = FactoryGirl.create(:region)),
                                                            :user => @user = FactoryGirl.create(:user))
      end

      it {@region.users.first.should be_a_kind_of User}
      it 'should return the correct users' do
        FactoryGirl.create :user
        @region.users.should eq [@user]
      end
      it { expect {
        @region.destroy
      }.to change(User, :count).by(0)}
    end

    describe 'volunteers' do
      before :each do
        @vol = FactoryGirl.create(:volunteer, :work_zone => FactoryGirl.create(:work_zone, :region => @region = FactoryGirl.create(:region)))
      end

      it {@region.volunteers.first.should be_a_kind_of Volunteer}
      it 'should return the correct volunteers' do
        FactoryGirl.create :volunteer
        @region.volunteers.should eq [@vol]
      end
      it { expect {
        @region.destroy
      }.to change(Volunteer, :count).by(0)}
    end

    describe 'work_zones' do
      before :each do
        @work_zone = FactoryGirl.create(:work_zone, :region => @region = FactoryGirl.create(:region))
      end

      it {@region.work_zones.first.should be_a_kind_of WorkZone}
      it 'should return the correct work_zones' do
        FactoryGirl.create :work_zone
        @region.work_zones.should eq [@work_zone]
      end
      it { expect {
        @region.destroy
      }.to change(WorkZone, :count).by(-1)}
    end
  end

  describe 'methods' do
    describe 'to_param' do
      it 'should be id and name' do
        region = FactoryGirl.create(:region)
        region.to_param.should eq "#{region.id}-#{region.name.parameterize}"
      end
    end

    describe 'work_zones?' do
      it {Region.new.work_zones?.should_not be_true}

      it 'should be true after adding work zones' do
        FactoryGirl.create(:work_zone, :region => @region = FactoryGirl.create(:region))
        @region.work_zones?.should be_true
      end
    end
  end

  describe 'scopes' do
    describe 'default' do
      it 'should order by name' do
        @a = FactoryGirl.create(:region, :name => 'Aaa')
        @c = FactoryGirl.create(:region, :name => 'Ccc')
        @b = FactoryGirl.create(:region, :name => 'Bbb')
        Region.all.should eq [@a,@b,@c]
      end
    end
  end
end
