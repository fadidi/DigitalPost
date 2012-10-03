require 'spec_helper'

describe Staff do
  before :each do
    @attr = {
      :user_id => 1
    }
  end

  it {Staff.create! @attr}

  # properties
  it {should respond_to :location}
  it {should respond_to :job_description_html}
  it {should respond_to :job_description_markdown}
  it {should respond_to :job_title}
  it {should respond_to :unit_id}
  it {should respond_to :user_id}

  # associations
  it {should respond_to :sectors}
  it {should respond_to :user}
  it {should respond_to :unit}

  #methods
  it {should respond_to :name}
  it {should respond_to :to_param}
  it {should respond_to :unit?}

  describe 'properties' do
    before :each do
      @staff = Staff.new
    end

    describe 'location' do
      it {@staff.location.should be_blank}
    end

    describe 'job_description_html' do
      it {@staff.job_description_html.should be_blank}

      it 'should populate on save' do
        @staff.user_id = 1
        @staff.save!
        @staff.job_description_html.should_not be_blank
      end

      it 'should update from job_description_markdown' do
        @staff.job_description_markdown = 'new job desc'
        @staff.user_id = 1
        @staff.save!
        @staff.job_description_html.should =~ /new job desc/i
      end  
    end

    describe 'job_description_markdown' do
      it {@staff.job_description_markdown.should_not be_blank}
    end

    it {@staff.job_title.should be_blank}
    it {@staff.unit_id.should be_blank}

    describe 'user_id' do
      it {@staff.user_id.should be_blank}
    end
  end

  describe 'validations' do
    it {Staff.new(@attr.merge(:location => '')).should be_valid}
    it {Staff.new(@attr.merge(:job_description_html => '')).should be_valid}
    it {Staff.new(@attr.merge(:job_description_markdown => '')).should be_valid}
    it {Staff.new(@attr.merge(:job_title => '')).should be_valid}
    it {Staff.new(@attr.merge(:job_title => 'a'*256)).should_not be_valid}

    describe 'user_id' do
      it {Staff.new(@attr.merge(:user_id => '')).should_not be_valid}
      it {Staff.new(@attr.merge(:user_id => 'a')).should_not be_valid}

      it 'should be unique' do
        Staff.create(@attr)
        Staff.new(@attr).should_not be_valid
      end
    end

    it {Staff.new(@attr.merge(:unit_id => '')).should be_valid}
    it {Staff.new(@attr.merge(:unit_id => 'a')).should_not be_valid}
  end

  describe 'associations' do
    describe 'sectors' do
      before :each do
        @sector = FactoryGirl.create(:sector, :apcd => @staff = FactoryGirl.create(:staff))
      end

      it {@staff.sectors.first.should be_an_instance_of Sector}

      it 'should be the correct sector' do
        FactoryGirl.create :sector
        @staff.sectors.should eq [@sector]
      end

      it { expect {
        @staff.destroy
      }.to change(Sector, :count).by(0)}

      it 'sholud nullify sectors' do
        @staff.destroy
        @sector.reload
        @sector.apcd_id.should be_blank
      end
    end

    describe 'user' do
      before :each do
        @staff = FactoryGirl.create(:staff, :user => @user = FactoryGirl.create(:user))
      end

      it 'should be a user' do
        @staff.user.should be_an_instance_of User
      end

      it 'should be the correct user' do
        FactoryGirl.create :user
        @staff.user.should eq @user
      end

      it { expect {
        @staff.destroy
      }.to change(User, :count).by(0)}
    end

    describe 'unit' do
      before :each do
        @staff = FactoryGirl.create(:staff, :unit => @unit = FactoryGirl.create(:unit))
      end

      it 'should be a unit' do
        @staff.unit.should be_an_instance_of Unit
      end

      it 'should be the correct user' do
        FactoryGirl.create :unit
        @staff.unit.should eq @unit
      end

      it { expect {
        @staff.destroy
      }.to change(Unit, :count).by(0)}
    end
  end

  describe 'methods' do
    describe 'name' do
      it 'should be the user name' do
        @staff = FactoryGirl.create(:staff, :user => @user = FactoryGirl.create(:user))
        @staff.name.should eq @user.name
      end
    end

    describe 'to_param' do
      before :each do
        @staff = FactoryGirl.create(:staff, :user => @user = FactoryGirl.create(:user))
      end

      it 'should use the user id' do
        @staff.to_param.should eq "#{@staff.user.id}-#{@staff.user.name.parameterize}"
      end
    end

    describe 'unit?' do
      it {Staff.new.unit?.should_not be_true}

      it 'it should be true with a unit set' do
        FactoryGirl.create(:staff, :unit => FactoryGirl.create(:unit)).unit?.should be_true
      end
    end
  end
end
