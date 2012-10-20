require 'spec_helper'

describe Language do
  before :each do
    @attr = {
      :code => 'en',
      :name => 'English'
    }
  end

  it {Language.create! @attr}

  # attributes
  it {should respond_to :code}
  it {should respond_to :name}
  it {should respond_to :description}

  # associations
  it {should respond_to :case_studies}
  it {should respond_to :documents}
  it {should respond_to :links}
  it {should respond_to :pages}
  pending {should respond_to :videos}

  # methods

  describe 'attributes' do
    describe 'code' do
      it {Language.new.code.should be_blank}

      it 'should upcase when saving' do
        lang = Language.create(@attr.merge(:code => 'up'))
        lang.code.should eq 'UP'
      end
    end

    it {Language.new.name.should be_blank}
    it {Language.new.description.should be_blank}
  end

  describe 'validations' do
    it {Language.new(@attr.merge(:code => '')).should_not be_valid}
    it {Language.new(@attr.merge(:code => 'a'*1)).should_not be_valid}
    it {Language.new(@attr.merge(:code => 'a'*256)).should_not be_valid}
    it {FactoryGirl.build(:language, :code => FactoryGirl.create(:language).code).should_not be_valid}
    it {Language.new(@attr.merge(:name => '')).should_not be_valid}
    it {Language.new(@attr.merge(:name => 'a'*256)).should_not be_valid}
    it {FactoryGirl.build(:language, :name => FactoryGirl.create(:language).name).should_not be_valid}
    it {Language.new(@attr.merge(:description => '')).should be_valid}
  end

  describe 'associations' do
    describe 'case studies' do
      before :each do
        @cs = FactoryGirl.create(:case_study, :language => @language = FactoryGirl.create(:language))
      end

      it {@language.case_studies.first.should be_a_kind_of CaseStudy}

      it 'should be the correct case studies' do
        FactoryGirl.create :case_study
        @language.case_studies.should eq [@cs]
      end

      it { expect {
        @language.destroy
      }.to change(CaseStudy, :count).by(0)}

      it 'should reset the language_id on the case study' do
        @language.destroy
        @cs.reload
        @cs.language_id.should be_blank
      end
    end

    describe 'documents' do
      before :each do
        @doc = FactoryGirl.create(:document, :language => @language = FactoryGirl.create(:language))
      end

      it {@language.documents.first.should be_a_kind_of Document}

      it 'should be the correct docs' do
        FactoryGirl.create :document
        @language.documents.should eq [@doc]
      end

      it { expect {
        @language.destroy
      }.to change(Document, :count).by(0)}

      it 'should reset the language_id on the document' do
        @language.destroy
        @doc.reload
        @doc.language_id.should be_blank
      end
    end

    describe 'links' do
      before :each do
        @link = FactoryGirl.create(:link, :language => @language = FactoryGirl.create(:language))
      end

      it {@language.links.first.should be_a_kind_of Link}

      it 'should be the correct links' do
        FactoryGirl.create :link
        @language.links.should eq [@link]
      end

      it { expect {
        @language.destroy
      }.to change(Link, :count).by(0)}

      it 'should reset the language_id on the link' do
        @language.destroy
        @link.reload
        @link.language_id.should be_blank
      end
    end

    describe 'pages' do
      before :each do
        @page = FactoryGirl.create(:page, :language => @language = FactoryGirl.create(:language))
      end

      it {@language.pages.first.should be_a_kind_of Page}

      it 'should be the correct pages' do
        FactoryGirl.create :page
        @language.pages.should eq [@page]
      end

      it { expect {
        @language.destroy
      }.to change(Page, :count).by(0)}

      it 'should reset the language_id on the page' do
        @language.destroy
        @page.reload
        @page.language_id.should eq 1
      end
    end
  end

  describe 'scopes' do
    describe 'default' do
      it 'should sort alphabetically' do
        @a = FactoryGirl.create(:language, :name => 'Aaa')
        @c = FactoryGirl.create(:language, :name => 'Ccc')
        @b = FactoryGirl.create(:language, :name => 'Bbb')
        Language.all.should eq [@a,@b,@c]
      end
    end
  end
end
