require 'spec_helper'

describe Timeline do
  before :each do
    @attr = {
      :headline => 'Test Headline',
      :startdate => '2012-01-01'
    }
  end

  it {Timeline.create! @attr}

  # attributes
  it {should respond_to :asset_caption}
  it {should respond_to :asset_credit}
  it {should respond_to :asset_media}
  it {should respond_to :headline}
  it {should respond_to :startdate}
  it {should respond_to :text}
  it {should respond_to :}
 
  # associations
  pending {should respond_to :moments}

  describe 'attributes' do
    it {Timeline.new.asset_caption.should be_blank}
    it {Timeline.new.asset_credit.should be_blank}
    it {Timeline.new.asset_media.should be_blank}
    it {Timeline.new.headline.should be_blank}
    it {Timeline.new.startdate.should be_blank}
    it {Timeline.new.text.should be_blank}
    it {Timeline.new.ttype.should_not be_blank}
    it {Timeline.new.ttype.should eq 'default'}
  end

  describe 'validations' do
    it {Timeline.new(@attr.merge(:asset_caption => '')).should be_valid}
    it {Timeline.new(@attr.merge(:asset_caption => 'a'*256)).should_not be_valid}
    it {Timeline.new(@attr.merge(:asset_credit => '')).should be_valid}
    it {Timeline.new(@attr.merge(:asset_credit => 'a'*256)).should_not be_valid}
    it {Timeline.new(@attr.merge(:asset_media => '')).should be_valid}
   
    describe 'headline' do
      it {Timeline.new(@attr.merge(:headline => '')).should_not be_valid}
      it {Timeline.new(@attr.merge(:headline => 'a'*256)).should_not be_valid}
      it 'should validate uniqueness' do
        Timeline.create! @attr
        Timeline.new(@attr.merge(:headline => @attr[:headline].upcase)).should_not be_valid
      end
    end

    it {Timeline.new(@attr.merge(:startdate => '')).should_not be_valid}
    it {Timeline.new(@attr.merge(:startdate => 'a')).should_not be_valid}
    it {Timeline.new(@attr.merge(:startdate => '1')).should_not be_valid}
    it {Timeline.new(@attr.merge(:startdate => '2012-01-01')).should be_valid}
    it {Timeline.new(@attr.merge(:text => '')).should be_valid}
    it {Timeline.new(@attr.merge(:ttype => '')).should be_valid}
    it {Timeline.new(@attr.merge(:ttype => 'a'*256)).should_not be_valid}
  end
end
