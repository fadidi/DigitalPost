require 'spec_helper'

describe Moment do
  before :each do
    @attr = {
      :headline => 'testing',
      :startdate => '2012-01-01',
      :timeline_id => FactoryGirl.create(:timeline).id,
      :user_id => FactoryGirl.create(:user).id
    }
  end

  it {Moment.create! @attr}

  # attributes
  it {should respond_to :asset_caption}
  it {should respond_to :asset_credit}
  it {should respond_to :asset_media}
  it {should respond_to :enddate}
  it {should respond_to :headline}
  it {should respond_to :startdate}
  it {should respond_to :text}
  it {should respond_to :timeline_id}
  it {should respond_to :user_id}

  # associations
  it {should respond_to :timeline}
  it {should respond_to :user}

  describe 'attributes' do
    it {Moment.new.asset_caption.should be_blank}
    it {Moment.new.asset_credit.should be_blank}
    it {Moment.new.asset_media.should be_blank}
    describe 'enddate' do
      it {Moment.new.enddate.should be_blank}
      it 'should be set to the startdate if blank' do
        @moment = Moment.create!(@attr.merge(:enddate => ''))
        @moment.enddate.should eq @attr[:startdate].to_date
      end
    end
    it {Moment.new.headline.should be_blank}
    it {Moment.new.startdate.should be_blank}
    it {Moment.new.text.should be_blank}
    it {Moment.new.timeline_id.should be_blank}
    it {Moment.new.user_id.should be_blank}
  end

  describe 'validations' do
    it {Moment.new(@attr.merge(:asset_caption => '')).should be_valid}
    it {Moment.new(@attr.merge(:asset_caption => 'a'*256)).should_not be_valid}
    it {Moment.new(@attr.merge(:asset_credit => '')).should be_valid}
    it {Moment.new(@attr.merge(:asset_credit => 'a'*256)).should_not be_valid}
    it {Moment.new(@attr.merge(:asset_media => '')).should be_valid}
    it {Moment.new(@attr.merge(:enddate => '')).should be_valid}
    it {Moment.new(@attr.merge(:enddate => '2012-01-01')).should be_valid}
    it {Moment.new(@attr.merge(:headline => '')).should_not be_valid}
    it {Moment.new(@attr.merge(:headline => 'a'*256)).should_not be_valid}
    it {Moment.new(@attr.merge(:startdate => '')).should_not be_valid}
    it {Moment.new(@attr.merge(:startdate => '2012-01-01')).should be_valid}
    it {Moment.new(@attr.merge(:text => '')).should be_valid}
    it {Moment.new(@attr.merge(:timeline_id => '')).should_not be_valid}
    it {Moment.new(@attr.merge(:timeline_id => 'a')).should_not be_valid}
    it {Moment.new(@attr.merge(:user_id => '')).should_not be_valid}
    it {Moment.new(@attr.merge(:user_id => 'a')).should_not be_valid}
  end

  describe 'associations' do
    describe 'timeline' do
      before :each do
        @moment = FactoryGirl.create(:moment, :timeline => @timeline = FactoryGirl.create(:timeline))
      end

      it {@moment.timeline.should be_a_kind_of Timeline}
      it {@moment.timeline.should eq @timeline}
      it { expect {
        @moment.destroy
      }.to change(Timeline, :count).by(0)}
    end

    describe 'user' do
      before :each do
        @moment = FactoryGirl.create(:moment, :user => @user = FactoryGirl.create(:user))
      end

      it {@moment.user.should be_a_kind_of User}
      it {@moment.user.should eq @user}
      it { expect {
        @moment.destroy
      }.to change(User, :count).by(0)}
    end
  end
end
