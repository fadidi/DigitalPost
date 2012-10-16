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
  pending {should respond_to :case_studies}
  pending {should respond_to :documents}
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
