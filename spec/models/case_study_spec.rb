require 'spec_helper'

describe CaseStudy do
  before :each do
    @attr = {
      :approach => 'test',
      :challenges => 'test',
      :context => 'test',
      :language_id => FactoryGirl.create(:language).id,
      :lessons => 'test',
      :recommendations => 'test',
      :results => 'test',
      :summary => 'test',
      :title => 'test title'
    }
  end

  it {CaseStudy.create! @attr}

  # attributes
  it {should respond_to :approach}
  it {should respond_to :challenges}
  it {should respond_to :context}
  it {should respond_to :html}
  it {should respond_to :language_id}
  it {should respond_to :lessons}
  it {should respond_to :recommendations}
  it {should respond_to :results}
  it {should respond_to :summary}
  it {should respond_to :title}

  # associations
  it {should respond_to :language}

  # methods

  describe 'attributes' do
    it {CaseStudy.new.approach.should be_blank}
    it {CaseStudy.new.challenges.should be_blank}
    it {CaseStudy.new.context.should be_blank}

    describe 'html' do
      it {CaseStudy.new.html.should be_blank}

      it 'should populate on successful save' do
        @cs = CaseStudy.create! @attr
        @cs.reload
        @cs.html.should_not be_blank
      end

      it 'should have the headings' do
        CaseStudy.create!(@attr).html.should =~ /<h3>Summary/i
      end
    end

    it {CaseStudy.new.language_id.should be_blank}
    it {CaseStudy.new.lessons.should be_blank}
    it {CaseStudy.new.recommendations.should be_blank}
    it {CaseStudy.new.results.should be_blank}
    it {CaseStudy.new.summary.should be_blank}
    it {CaseStudy.new.title.should be_blank}
  end

  describe 'validations' do
    it {CaseStudy.new(@attr.merge(:approach => '')).should_not be_valid}
    it {CaseStudy.new(@attr.merge(:challenges => '')).should_not be_valid}
    it {CaseStudy.new(@attr.merge(:context => '')).should_not be_valid}
    it {CaseStudy.new(@attr.merge(:html => '')).should be_valid}
    it {CaseStudy.new(@attr.merge(:language_id => '')).should_not be_valid}
    it {CaseStudy.new(@attr.merge(:language_id => 'a')).should_not be_valid}
    it {CaseStudy.new(@attr.merge(:lessons => '')).should_not be_valid}
    it {CaseStudy.new(@attr.merge(:recommendations => '')).should_not be_valid}
    it {CaseStudy.new(@attr.merge(:results => '')).should_not be_valid}
    it {CaseStudy.new(@attr.merge(:summary => '')).should_not be_valid}

    describe 'title' do
      it {CaseStudy.new(@attr.merge(:title => '')).should_not be_valid}
      it {CaseStudy.new(@attr.merge(:title => 'a'*7)).should_not be_valid}
      it {CaseStudy.new(@attr.merge(:title => 'a'*256)).should_not be_valid}

      it 'should not allow duplicates' do
        CaseStudy.create! @attr
        CaseStudy.new(@attr.merge(:title => @attr[:title].upcase)).should_not be_valid
      end
    end
  end

  describe 'associations' do
    describe 'language' do
      before :each do
        @cs = FactoryGirl.create(:case_study, :language => @lang = FactoryGirl.create(:language))
      end

      it {@cs.language.should be_a_kind_of Language}
      it {@cs.language.should eq @lang}
      it { expect {
        @cs.destroy
      }.to change(Language, :count).by(0)}
    end
  end
end
