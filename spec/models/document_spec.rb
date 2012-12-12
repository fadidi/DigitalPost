require 'spec_helper'

describe Document do
  before :each do
    @attr = FactoryGirl.attributes_for(:document).merge(:language_id => FactoryGirl.create(:language).id, :user_id => FactoryGirl.create(:user).id)
  end

  it {Document.create! @attr}

  # attributes
  it {should respond_to :author}
  it {should respond_to :file}
  it {should respond_to :file_content_type}
  it {should respond_to :file_file_size}
  it {should respond_to :file_hash}
  it {should respond_to :description}
  it {should respond_to :language_id}
  it {should respond_to :photo}
  it {should respond_to :source}
  it {should respond_to :source_content_type}
  it {should respond_to :source_file_size}
  it {should respond_to :title}
  it {should respond_to :restricted}
  it {should respond_to :user_id}

  # associations
  it {should respond_to :language}
  it {should respond_to :user}

  # methods
  it {should respond_to :restricted?}
  it {should respond_to :to_param}

  # carrierwave
  it {should respond_to :file?}
  it {should respond_to :photo?}
  it {should respond_to :remove_file}
  it {should respond_to :remove_file!}
  it {should respond_to :remove_photo}
  it {should respond_to :remove_photo!}
  it {should respond_to :remove_source}
  it {should respond_to :remove_source!}
  it {should respond_to :source?}

  describe 'attrubutes' do
    it {Document.new.author.should be_blank}

    describe 'file fields' do
      context 'without file' do
        it {Document.new.file.should be_blank}
        it {Document.new.file_content_type.should be_blank}
        it {Document.new.file_file_size.should be_blank}
      end

      context 'with file' do
        before :each do
          @doc = FactoryGirl.create :document
        end

        it {@doc.file.should_not be_blank}
        it {@doc.file_content_type.should_not be_blank}
        it {@doc.file_file_size.should_not be_blank}
        it {@doc.file_hash.should_not be_blank}
      end
    end

    it {Document.new.description.should be_blank}
    it {Document.new.language_id.should be_blank}
    it {Document.new.photo.should be_blank}

    describe 'source fields' do
      context 'without source' do
        it {Document.new.source.should be_blank}
        it {Document.new.source_content_type.should be_blank}
        it {Document.new.source_file_size.should be_blank}
      end

      context 'with source' do
        before :each do
          @doc = FactoryGirl.build :document
          @doc.source = (File.open('spec/support/documents/sample.txt'))
          @doc.save!
        end

        it {@doc.source.should_not be_blank}
        it {@doc.source_content_type.should_not be_blank}
        it {@doc.source_file_size.should_not be_blank}
      end
    end

    it {Document.new.title.should be_blank}
    it {FactoryGirl.create(:document, :title => '').title.should_not be_blank}
    it {Document.new.restricted.should be_false}
    it {Document.new.restricted.should eq false}
    it {Document.new.user_id.should be_blank}
  end

  describe 'validations' do
    it {Document.new(@attr.merge(:author => '')).should be_valid}
    it {Document.new(@attr.merge(:author => 'a'*256)).should_not be_valid}
    it {Document.new(@attr.merge(:file => '')).should_not be_valid}
    it {Document.new(@attr.merge(:file_content_type => '')).should be_valid}
    it {Document.new(@attr.merge(:file_file_size => '')).should be_valid}
    it {Document.new(@attr.merge(:file_hash => '')).should be_valid}
    it {Document.new(@attr.merge(:description => '')).should be_valid}
    it {Document.new(@attr.merge(:language_id => '')).should_not be_valid}
    it {Document.new(@attr.merge(:language_id => 'a')).should_not be_valid}
    it {Document.new(@attr.merge(:photo => '')).should be_valid}
    it {Document.new(@attr.merge(:source => '')).should be_valid}
    it {Document.new(@attr.merge(:source_content_type => '')).should be_valid}
    it {Document.new(@attr.merge(:source_file_size => '')).should be_valid}
    it {Document.new(@attr.merge(:title => '')).should be_valid}
    it {Document.new(@attr.merge(:title => 'a'*256)).should_not be_valid}
    it {Document.new(@attr.merge(:restricted => '')).should be_valid}
    it {Document.new(@attr.merge(:restricted => true)).should be_valid}
    it {Document.new(@attr.merge(:user_id => '')).should_not be_valid}
    it {Document.new(@attr.merge(:user_id => 'a')).should_not be_valid}
  end

  describe 'associations' do
    describe 'language' do
      before :each do
        @doc = FactoryGirl.create(:document, :language => @lang = FactoryGirl.create(:language))
      end

      it {@doc.language.should be_a_kind_of Language}

      it 'should be the correct language' do
        FactoryGirl.create :language
        @doc.language.should eq @lang
      end

      it { expect {
        @doc.destroy
      }.to change(Language, :count).by(0)}
    end

    describe 'user' do
      before :each do
        @doc = FactoryGirl.create(:document, :user => @user = FactoryGirl.create(:user))
      end

      it {@doc.user.should be_a_kind_of User}

      it 'should be the correct user' do
        FactoryGirl.create :user
        @doc.user.should eq @user
      end

      it { expect {
        @doc.destroy
      }.to change(User, :count).by(0)}
    end
  end

  describe 'methods' do
    describe 'restricted?' do
      it {Document.new.restricted?.should be_false}
      it {@doc = Document.new(@attr.merge(:restricted => true)).restricted?.should be_true}
    end

    describe 'to_param' do
      it 'should set title in to_param' do
        @doc = FactoryGirl.create(:document)
        @doc.to_param.should eq "#{@doc.id}-#{@doc.title.parameterize}"
      end
    end
  end

  describe 'scopes' do
    describe 'default' do
      it 'should order by id desc' do
        @a = FactoryGirl.create(:document, :title => 'Aaa')
        @b = FactoryGirl.create(:document, :title => 'Bbb')
        @c = FactoryGirl.create(:document, :title => 'Ccc')
        Document.all.should eq [@c, @b, @a]
      end
    end
  end
end
