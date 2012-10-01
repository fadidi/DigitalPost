require 'spec_helper'

describe Stage do
  before :each do
    @attr = {}
    @set_attr = {
      :anticipated_cos => Time.now + 2.years,
      :arrival => Time.now - 90.days,
      :swear_in => Time.now
    }
  end

  it {Stage.create! @attr}

  # properties
  it {should respond_to :anticipated_cos}
  it {should respond_to :arrival}
  it {should respond_to :swear_in}

  # associations
  it {should respond_to :volunteers}
  it {should respond_to :users}
  
  # methods
  it {should respond_to :name}

  describe 'properties' do
    describe 'anticipated_cos' do
      it {Stage.new.anticipated_cos.should_not be_blank}
      it {Stage.new.anticipated_cos.to_date.should eq (Time.now + 820.days).to_date}
    end
    
    describe 'arrival' do
      it {Stage.new.arrival.should_not be_blank}
      it {Stage.new.arrival.to_date.should eq Time.now.to_date}
    end

    describe 'swear_in' do
      it {Stage.new.swear_in.should_not be_blank}
      it {Stage.new.swear_in.to_date.should eq (Time.now + 90.days).to_date}
    end
  end

  describe 'validations' do
    before :each do
      @stage = Stage.new @attr
    end

    it {@stage.should be_valid}

    describe 'anticipated_cos' do
      it 'should reject duplicates' do
        stage1 = Stage.new
        stage1.update_attributes(@set_attr)
        stage2 = Stage.new
        stage2.anticipated_cos = @set_attr[:anticipated_cos]
        puts stage1.anticipated_cos
        puts stage2.anticipated_cos
        stage2.should_not be_valid
      end

      it 'should reject invalid format dates' do
        @stage.anticipated_cos = '1963-24-21'
        @stage.should_not be_valid
      end

      it 'should reject too old dates' do
        @stage.anticipated_cos = '1960-12-31'
        @stage.should_not be_valid
      end

      it 'should allow future dates' do
        @stage.anticipated_cos = Time.now + 1.year
        @stage.should be_valid
      end
    end

    describe 'arrival' do
      it 'should reject invalid format dates' do
        @stage.arrival = '1963-24-21'
        @stage.should_not be_valid
      end

      it 'should reject too old dates' do
        @stage.arrival = '1960-12-31'
        @stage.should_not be_valid
      end

      it 'should allow future dates' do
        @stage.arrival = Time.now + 1.year
        @stage.should be_valid
      end
    end

    describe 'swear_in' do
      it 'should reject invalid format dates' do
        @stage.swear_in = '1963-24-21'
        @stage.should_not be_valid
      end

      it 'should reject too old dates' do
        @stage.swear_in = '1960-12-31'
        @stage.should_not be_valid
      end

      it 'should allow future dates' do
        @stage.swear_in = Time.now + 1.year
        @stage.should be_valid
      end
    end
  end

  describe 'methods' do
    describe 'name' do
      it {Stage.new.name.should_not be_blank}
      
      it 'should be composed of arrival Month Year' do
        date = Time.now
        Stage.new(@attr.merge(:arrival => date)).name.should eq date.strftime('%B %Y')
      end
    end
  end

  describe 'scopes' do
    describe 'default' do
      it 'should be arrival DESC' do
        @stage1 = FactoryGirl.create(:stage, :arrival => Time.now)
        @stage2 = FactoryGirl.create(:stage, :arrival => Time.now + 1.day)
        @stage3 = FactoryGirl.create(:stage, :arrival => Time.now - 1.day)
        [@stage1,@stage2,@stage3].each { |stage| stage.save! }
        Stage.all.should eq [@stage2,@stage1,@stage3]
      end
    end
  end
end
