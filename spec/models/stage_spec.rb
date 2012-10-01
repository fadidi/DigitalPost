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

  # settings?
  it {Stage.should respond_to :per_page}

  # associations
  it {should respond_to :volunteers}
  it {should respond_to :users}
  
  # methods
  it {should respond_to :name}
  it {should respond_to :to_param}

  describe 'properties' do
    describe 'anticipated_cos' do
      it {Stage.new.anticipated_cos.should_not be_blank}
      it {Stage.new.anticipated_cos.should eq (Date.today + 820.days)}
    end
    
    describe 'arrival' do
      it {Stage.new.arrival.should_not be_blank}
      it {Stage.new.arrival.should eq Date.today}
    end

    describe 'swear_in' do
      it {Stage.new.swear_in.should_not be_blank}
      it {Stage.new.swear_in.to_date.should eq (Date.today + 90.days).to_date}
    end
  end

  describe 'settings' do
    it {Stage.per_page.should eq 20}
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
        @stage.anticipated_cos = Date.today + 1.year
        @stage.should be_valid
      end
    end

    describe 'arrival' do
      it 'should reject duplicates' do
        stage1 = Stage.new
        stage1.update_attributes(@set_attr)
        stage2 = Stage.new
        stage2.arrival = @set_attr[:arrival]
        stage2.should_not be_valid
      end

      it 'should reject invalid format dates' do
        @stage.arrival = '1963-24-21'
        @stage.should_not be_valid
      end

      it 'should reject too old dates' do
        @stage.arrival = '1960-12-31'
        @stage.should_not be_valid
      end

      it 'should allow future dates' do
        @stage.arrival = Date.today + 1.year
        @stage.should be_valid
      end
    end

    describe 'swear_in' do
      it 'should reject duplicates' do
        stage1 = Stage.new
        stage1.update_attributes(@set_attr)
        stage2 = Stage.new
        stage2.swear_in = @set_attr[:swear_in]
        stage2.should_not be_valid
      end

      it 'should reject invalid format dates' do
        @stage.swear_in = '1963-24-21'
        @stage.should_not be_valid
      end

      it 'should reject too old dates' do
        @stage.swear_in = '1960-12-31'
        @stage.should_not be_valid
      end

      it 'should allow future dates' do
        @stage.swear_in = Date.today + 1.year
        @stage.should be_valid
      end
    end
  end

  describe 'associations' do
    describe 'volunteers' do
      before :each do
        @volunteer = FactoryGirl.create(:volunteer, :stage => @stage = FactoryGirl.create(:stage))
      end
      
      it {@stage.volunteers.first.should be_a_kind_of Volunteer}
      
      it 'should return the correct volunteers' do
        FactoryGirl.create :volunteer
        @stage.volunteers.should eq [@volunteer]
      end

      it 'should not destroy volunteers' do
        expect {
          @stage.destroy
        }.to change(Volunteer, :count).by(0)
      end
    end

    describe 'users' do
      before :each do
        FactoryGirl.create(:volunteer, :user => @user = FactoryGirl.create(:user), :stage => @stage = FactoryGirl.create(:stage))
      end
      
      it {@stage.users.first.should be_a_kind_of User}
      
      it 'should return the correct volunteers' do
        FactoryGirl.create :volunteer
        @stage.users.should eq [@user]
      end

      it 'should not destroy users' do
        expect {
          @stage.destroy
        }.to change(User, :count).by(0)
      end
    end
  end

  describe 'methods' do
    describe 'name' do
      it {Stage.new.name.should_not be_blank}
      
      it 'should be composed of arrival Month Year' do
        date = Date.today
        Stage.new(@attr.merge(:arrival => date)).name.should eq date.strftime('%B %Y')
      end
    end
    
    describe 'to_param' do
      it 'should be stage name' do
        stage = FactoryGirl.create(:stage)
        stage.to_param.should eq "#{stage.id}-#{stage.name.parameterize}"
      end
    end
  end

  describe 'scopes' do
    describe 'default' do
      it 'should be arrival DESC' do
        stage1 = FactoryGirl.create(:stage)
        stage1.update_attributes(:arrival => Date.today - 2.days)
        stage2 = FactoryGirl.create(:stage)
        stage2.update_attributes(:arrival => Date.today - 1.day)
        stage3 = FactoryGirl.create(:stage)
        stage3.update_attributes(:arrival => Date.today - 3.days)
        Stage.all.should eq [stage2,stage1,stage3]
      end
    end
  end
end
