require 'spec_helper'

describe WorkZone do
  before :each do
    @attr = {
      :name => 'New Work Zone',
      :abbreviation => 'NWZ',
      :region_id => FactoryGirl.create(:region).id
    }
  end

  it {WorkZone.create! @attr}

  # properties
  it {should respond_to :abbreviation}
  it {should respond_to :leader_id}
  it {should respond_to :name}
  it {should respond_to :photo}
  it {should respond_to :region_id}

  # associations
  it {should respond_to :leader}
  it {should respond_to :region}
  it {should respond_to :users}
  it {should respond_to :volunteers}

  # methods
  it {should respond_to :leader?}
  it {should respond_to :to_param}

  # carrierwave
  it {should respond_to :photo?}
  it {should respond_to :remove_photo}
  it {should respond_to :remove_photo!}

  describe 'properties' do
    it {WorkZone.new.abbreviation.should be_blank}
    it {WorkZone.new.leader_id.should be_blank}
    it {WorkZone.new.name.should be_blank}

    describe 'photo' do
      it {WorkZone.new.photo.should be_blank}

      it 'should populate on upload' do
        @wz = FactoryGirl.create :work_zone
        @wz.photo = (File.open('spec/support/images/10x10.gif'))
        @wz.save!
        @wz.photo.should_not be_blank
      end
    end
    
    it {WorkZone.new.region_id.should be_blank}
  end

  describe 'validations' do
    describe 'abbreviation' do
      it {WorkZone.new(@attr.merge(:abbreviation => '')).should_not be_valid}
      it {WorkZone.new(@attr.merge(:abbreviation => 'a')).should_not be_valid}
      it {WorkZone.new(@attr.merge(:abbreviation => 'a'*9)).should_not be_valid}

      it 'should not allow duplicates up to case' do
        WorkZone.create! @attr.merge(:abbreviation => 'Test')
        WorkZone.new(@attr.merge(:abbreviation => 'Test'.upcase)).should_not be_valid
      end

      it 'should upcase when saving' do
        workzone = WorkZone.create(@attr.merge(:abbreviation => 'up'))
        workzone.abbreviation.should eq 'UP'
      end
    end

    it {WorkZone.new(@attr.merge(:leader_id => '')).should be_valid}
    it {WorkZone.new(@attr.merge(:leader_id => 'a')).should_not be_valid}
    it {WorkZone.new(@attr.merge(:photo => '')).should be_valid}

    describe 'name' do
      it {WorkZone.new(@attr.merge(:name => '')).should_not be_valid}
      it {WorkZone.new(@attr.merge(:name => 'a'*256)).should_not be_valid}

      describe 'validate uniqueness' do
        before :each do
          @work_zone = FactoryGirl.create(:work_zone)
        end

        it 'should allow duplicates with unique region_id' do
          FactoryGirl.build(:work_zone, :name => @work_zone.name.upcase).should be_valid
        end

        it 'should not allow duplicates with duplicate region_id' do
          FactoryGirl.build(:work_zone, :name => @work_zone.name.upcase, :region_id => @work_zone.region_id).should_not be_valid
        end
      end
    end

    it {WorkZone.new(@attr.merge(:region_id => '')).should_not be_valid}
    it {WorkZone.new(@attr.merge(:region_id => 'a')).should_not be_valid}
  end

  describe 'associations' do
    describe 'leader' do
      before :each do
        @work_zone = FactoryGirl.create(:work_zone, :leader => @vol = FactoryGirl.create(:volunteer))
      end

      it {@work_zone.leader.should be_a_kind_of Volunteer}
      it {@work_zone.leader.should eq @vol}
      it { expect {
        @work_zone.destroy
      }.to change(Volunteer, :count).by(0)}
    end

    describe 'region' do
      before :each do
        @work_zone = FactoryGirl.create(:work_zone, :region => @region = FactoryGirl.create(:region))
      end

      it {@work_zone.region.should be_a_kind_of Region}
      it {@work_zone.region.should eq @region}
      it { expect {
        @work_zone.destroy
      }.to change(Region, :count).by(0)}
    end

    describe 'users' do
      before :each do
        @volunteer =  FactoryGirl.create(:volunteer, :user => @user = FactoryGirl.create(:user), :work_zone => @work_zone = FactoryGirl.create(:work_zone))
      end

      it {@work_zone.users.first.should be_a_kind_of User}
      it 'should return the correct users' do
        FactoryGirl.create :user
        @work_zone.users.should eq [@user]
      end
      it { expect {
        @work_zone.destroy
      }.to change(User, :count).by(0)}
    end

    describe 'volunteers' do
      before :each do
        @volunteer =  FactoryGirl.create(:volunteer, :work_zone => @work_zone = FactoryGirl.create(:work_zone))
      end

      it {@work_zone.volunteers.first.should be_a_kind_of Volunteer}
      it {@work_zone.volunteers.should eq [@volunteer]}

      it { expect {
        @work_zone.destroy
      }.to change(Volunteer, :count).by(0)}

      it 'should nullify volunteer' do
        @work_zone.destroy
        @volunteer.reload.work_zone.should be_nil
      end
    end
  end

  describe 'methods' do
    describe 'leader?' do
      it 'should be false by default' do
        WorkZone.new.leader?.should_not be_true
      end

      it 'should be true with a leader' do
        FactoryGirl.create(:work_zone, :leader => FactoryGirl.create(:volunteer)).leader?.should be_true
      end
    end

    describe 'to_param' do
      it 'should be id and name' do
        work_zone = FactoryGirl.create(:work_zone)
        work_zone.to_param.should eq "#{work_zone.id}-#{work_zone.name.parameterize}"
      end
    end
  end

  describe 'scopes' do
    describe 'default' do
      it 'should order by name' do
        @a = FactoryGirl.create(:work_zone, :name => 'Aaa')
        @c = FactoryGirl.create(:work_zone, :name => 'Ccc')
        @b = FactoryGirl.create(:work_zone, :name => 'Bbb')
        WorkZone.all.should eq [@a,@b,@c]
      end
    end
  end
end
