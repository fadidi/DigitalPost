require 'spec_helper'

describe Sector do
  before :each do
    @attr = {
      :abbreviation => 'TST',
      :name => 'Test Sector'
    }
  end

  it {Sector.create! @attr}

  # attributes
  it {should respond_to :abbreviation}
  it {should respond_to :apcd_id}
  it {should respond_to :name}
  it {should respond_to :photo}

  # associations
  it {should respond_to :apcd}
  it {should respond_to :users}
  it {should respond_to :volunteers}

  # methods
  it {should respond_to :apcd?}
  it {should respond_to :to_param}

  # carrierwave
  it {should respond_to :photo?}
  it {should respond_to :remove_photo}
  it {should respond_to :remove_photo!}

  describe 'properties' do
    describe 'abbreviation' do
      it {Sector.new.abbreviation.should be_blank}

      it 'should upcase when saving' do
        sector = Sector.create(@attr.merge(:abbreviation => 'up'))
        sector.abbreviation.should eq 'UP'
      end
    end
    it {Sector.new.apcd_id.should be_blank}
    it {Sector.new.name.should be_blank}

    describe 'photo' do
      it {Sector.new.photo.should be_blank}

      it 'should populate on upload' do
        @sector = FactoryGirl.create :sector
        @sector.photo = (File.open('spec/support/images/10x10.gif'))
        @sector.save!
        @sector.photo.should_not be_blank
      end
    end
  end

  describe 'validations' do
    describe 'abbreviation' do
      it {Sector.new(@attr.merge(:abbreviation => '')).should_not be_valid}
      it {Sector.new(@attr.merge(:abbreviation => 'a'*1)).should_not be_valid}
      it {Sector.new(@attr.merge(:abbreviation => 'a'*8)).should_not be_valid}

      it 'should reject duplicates' do
        FactoryGirl.build(:sector, :abbreviation => FactoryGirl.create(:sector).abbreviation).should_not be_valid
      end
    end

    it {Sector.new(@attr.merge(:apcd_id => '')).should be_valid}
    it {Sector.new(@attr.merge(:apcd_id => 'a')).should_not be_valid}

    describe 'name' do
      it {Sector.new(@attr.merge(:name => '')).should_not be_valid}
      it {Sector.new(@attr.merge(:name => 'a'*256)).should_not be_valid}

      it 'should reject duplicates' do
        FactoryGirl.build(:sector, :name => FactoryGirl.create(:sector).name).should_not be_valid
      end
    end

    it {Sector.new(@attr.merge(:photo => '')).should be_valid}
  end

  describe 'associations' do
    describe 'apcd' do
      before :each do
        @sector = FactoryGirl.create(:sector, :apcd => @apcd = FactoryGirl.create(:staff))
      end

      it {@sector.apcd.should be_a_kind_of Staff}

      it 'should be the correct staff member' do
        FactoryGirl.create :staff
        @sector.apcd.should eq @apcd
      end

      it { expect {
        @sector.destroy
      }.to change(Staff, :count).by(0)}
    end

    describe 'users' do
      before :each do
        FactoryGirl.create(:volunteer, :user => @user = FactoryGirl.create(:user), :sector => @sector = FactoryGirl.create(:sector))
      end

      it {@sector.users.first.should be_a_kind_of User}

      it 'should be the correct users' do
        FactoryGirl.create :user
        @sector.users.should eq [@user]
      end

      it { expect {
        @sector.destroy
      }.to change(User, :count).by(0)}
    end

    describe 'volunteers' do
      before :each do
        @volunteer = FactoryGirl.create(:volunteer, :sector => @sector = FactoryGirl.create(:sector))
      end

      it {@sector.volunteers.first.should be_a_kind_of Volunteer}

      it 'should be the correct volunteers' do
        FactoryGirl.create :volunteer
        @sector.volunteers.should eq [@volunteer]
      end

      it { expect {
        @sector.destroy
      }.to change(Volunteer, :count).by(0)}

      it 'should nullify volunteers pointing to it' do
        @sector.destroy
        @volunteer.reload
        @volunteer.sector_id.should be_blank
      end
    end
  end

  describe 'methods' do
    describe 'apcd?' do
      it {Sector.new.apcd?.should_not be_true}
      it {FactoryGirl.create(:sector, :apcd => FactoryGirl.create(:staff)).apcd?.should be_true}
    end

    describe 'to_param' do
      it 'should be id and name' do
        @sector = FactoryGirl.create(:sector, :name => 'Test Sector')
        @sector.to_param.should eq "#{@sector.id}-#{@sector.name.parameterize}"
      end
    end
  end

  describe 'scopes' do
    describe 'default' do
      it 'should order by name ASC' do
        @a = FactoryGirl.create(:sector, :name => 'Aaa')
        @c = FactoryGirl.create(:sector, :name => 'Ccc')
        @b = FactoryGirl.create(:sector, :name => 'Bbb')
        Sector.all.should eq [@a, @b, @c]
      end
    end
  end

  describe 'carrierwave' do
    describe 'remove_photo' do
      it 'should remove the photo when true' do
        @sector = FactoryGirl.create :sector
        @sector.photo = (File.open('spec/support/images/10x10.gif'))
        @sector.save!
        @sector.update_attributes(:remove_photo => true)
        @sector.photo.should be_blank
      end
    end
  end
end
