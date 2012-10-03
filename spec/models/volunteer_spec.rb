require 'spec_helper'

describe Volunteer do
  before :each do
    @attr = {
      :user_id => 1
    }
  end

  it {Volunteer.create! @attr}

  # properties
  it {should respond_to :cos_date}
  it {should respond_to :local_name}
  it {should respond_to :sector_id}
  it {should respond_to :service_info_html}
  it {should respond_to :service_info_markdown}
  it {should respond_to :site}
  it {should respond_to :stage_id}
  it {should respond_to :user_id}
  it {should respond_to :work_zone_id}

  # associations
  it {should respond_to :region}
  it {should respond_to :sector}
  it {should respond_to :stage}
  it {should respond_to :user}
  it {should respond_to :work_zone}
  it {should respond_to :lead_work_zone}

  # methods
  it {should respond_to :region?}
  it {should respond_to :sector?}
  it {should respond_to :stage?}
  it {should respond_to :to_param}
  it {should respond_to :user_name}
  it {should respond_to :work_zone?}

  describe 'properties' do
    before :each do
      @vol = Volunteer.new
    end

    describe 'cos_date' do
      it {@vol.cos_date.should be_blank}

      it 'should set invalid formats to nil' do
        vol = Volunteer.new(@attr.merge(:cos_date => '1963-24-21'))
        vol.cos_date.should be_blank
      end
    end

    describe 'local_name' do
      it {@vol.local_name.should be_blank}
    end

    describe 'sector_id' do
      it {@vol.sector_id.should be_blank}
    end

    describe 'service_info_html' do
      it {@vol.service_info_html.should be_blank}

      it 'should populate on save' do
        @vol.user_id = 1
        @vol.save!
        @vol.service_info_html.should_not be_blank
      end

      it 'should update from service_info_markdown' do
        @vol.service_info_markdown = 'New text.'
        @vol.user_id = 1
        @vol.save!
        @vol.reload
        @vol.service_info_html.should =~ /new text/i
      end
    end

    describe 'service_info_markdown' do
      it {@vol.service_info_markdown.should_not be_blank}
    end

    describe 'site' do
      it {@vol.site.should be_blank}
    end

    describe 'stage_id' do
      it {@vol.stage_id.should be_blank}
    end

    describe 'user_id' do
      it {@vol.user_id.should be_blank}
    end

    it {Volunteer.new.work_zone_id.should be_blank}
  end

  describe 'validations' do
    describe 'cos_date' do
      it {Volunteer.new(@attr.merge(:cos_date => '')).should be_valid}
      # too old
      it {Volunteer.new(@attr.merge(:cos_date => '1960-12-31')).should_not be_valid}
      # future
      it {Volunteer.new(@attr.merge(:cos_date => Time.now + 1.year)).should be_valid}
    end

    it {Volunteer.new(@attr.merge(:local_name => '')).should be_valid}
    it {Volunteer.new(@attr.merge(:local_name => 'a'*256)).should_not be_valid}
    it {Volunteer.new(@attr.merge(:sector_id => '')).should be_valid}
    it {Volunteer.new(@attr.merge(:sector_id => 'a')).should_not be_valid}
    it {Volunteer.new(@attr.merge(:service_info_html => '')).should be_valid}
    it {Volunteer.new(@attr.merge(:service_info_markdown => '')).should be_valid}
    it {Volunteer.new(@attr.merge(:site => '')).should be_valid}
    it {Volunteer.new(@attr.merge(:stage_id => '')).should be_valid}
    it {Volunteer.new(@attr.merge(:stage_id => 'a')).should_not be_valid}

    describe 'user_id' do
      it {Volunteer.new(@attr.merge(:user_id => '')).should_not be_valid}
      it {Volunteer.new(@attr.merge(:user_id => 'a')).should_not be_valid}

      it 'should validate unique' do
        Volunteer.create!(@attr)
        Volunteer.new(@attr).should_not be_valid
      end
    end

    it {Volunteer.new(@attr.merge(:work_zone_id => '')).should be_valid}
    it {Volunteer.new(@attr.merge(:work_zone_id => 'a')).should_not be_valid}
  end

  describe 'associations' do
    describe 'region' do
      before :each do
        @vol = FactoryGirl.create(:volunteer, :work_zone => FactoryGirl.create(:work_zone, :region => @region = FactoryGirl.create(:region)))
      end

      it {@vol.region.should be_an_instance_of Region}

      it 'should be the correct region' do
        FactoryGirl.create :region
        @vol.region.should eq @region
      end

      it {expect {
        @vol.destroy
      }.to change(Region, :count).by(0)}
    end

    describe 'sector' do
      before :each do
        @vol = FactoryGirl.create(:volunteer, :sector => @sector = FactoryGirl.create(:sector))
      end

      it {@vol.sector.should be_an_instance_of Sector}

      it 'should be the correct sector' do
        FactoryGirl.create :sector
        @vol.sector.should eq @sector
      end

      it {expect {
        @vol.destroy
      }.to change(Sector, :count).by(0)}
    end

    describe 'user' do
      before :each do
        @vol = FactoryGirl.create(:volunteer, :user => @user = FactoryGirl.create(:user))
      end

      it 'should be a user' do
        @vol.user.should be_an_instance_of User
      end

      it 'should be the correct user' do
        FactoryGirl.create :user
        @vol.user.should eq @user
      end

      it {expect {
        @vol.destroy
      }.to change(User, :count).by(0)}
    end

    describe 'work_zone' do
      before :each do
        @vol = FactoryGirl.create(:volunteer, :work_zone => @work_zone = FactoryGirl.create(:work_zone))
      end

      it {@vol.work_zone.should be_an_instance_of WorkZone}

      it 'should be the correct work_zone' do
        FactoryGirl.create :work_zone
        @vol.work_zone.should eq @work_zone
      end

      it {expect {
        @vol.destroy
      }.to change(WorkZone, :count).by(0)}
    end

    describe 'lead_work_zone' do
      before :each do
        @work_zone = FactoryGirl.create(:work_zone, :leader => @vol = FactoryGirl.create(:volunteer))
      end

      it {@vol.lead_work_zone.should be_an_instance_of WorkZone}

      it 'should be the correct work_zone' do
        FactoryGirl.create :work_zone
        @vol.lead_work_zone.should eq @work_zone
      end

      it {expect {
        @vol.destroy
      }.to change(WorkZone, :count).by(0)}

      it 'should nullify lead_work_zone' do
        @vol.destroy
        @work_zone.reload
        @work_zone.leader_id.should be_blank
      end
    end
  end

  describe 'methods' do
    describe 'region?' do
      it {Volunteer.new.region?.should_not be_true}
      it {FactoryGirl.create(:volunteer, :work_zone_id => 1).region?.should_not be_true}
      it {FactoryGirl.create(:volunteer, :work_zone => FactoryGirl.create(:work_zone)).region?.should be_true}
    end

    describe 'sector?' do
      it {Volunteer.new.stage?.should_not be_true}
      it {FactoryGirl.create(:volunteer, :sector_id => 1).sector?.should_not be_true}
      it {FactoryGirl.create(:volunteer, :sector => FactoryGirl.create(:sector)).sector?.should be_true}
    end

    describe 'stage?' do
      it {Volunteer.new.stage?.should_not be_true}
      it {FactoryGirl.create(:volunteer, :stage_id => 1).stage?.should_not be_true}
      it {FactoryGirl.create(:volunteer, :stage => FactoryGirl.create(:stage)).stage?.should be_true}
    end

    describe 'to_param' do
      before :each do
        @vol = FactoryGirl.create(:volunteer, :user => @user = FactoryGirl.create(:user))
      end

      it 'should using the user id' do
        @vol.to_param.should eq "#{@vol.user.id}-#{@vol.user.name.parameterize}"
      end
    end

    describe 'user_name' do
      it {FactoryGirl.create(:volunteer, :user => @user = FactoryGirl.create(:user)).user_name.should eq @user.name}
    end

    describe 'work_zone?' do
      it {Volunteer.new.work_zone?.should_not be_true}

      it 'should be true with a work zone set' do
        FactoryGirl.create(:volunteer, :work_zone => FactoryGirl.create(:work_zone)).work_zone?.should be_true
      end
    end
  end
end
