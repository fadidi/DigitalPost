require 'spec_helper'

describe Photo do
  before :each do
    @attr = FactoryGirl.attributes_for(:photo).merge(:user_id => 1)
  end

  it {Photo.create! @attr}
  
  # properties
  it {should respond_to :attribution}
  it {should respond_to :description}
  it {should respond_to :photo_height}
  it {should respond_to :imageable_id}
  it {should respond_to :imageable_type}
  it {should respond_to :photo}
  it {should respond_to :photo_content_type}
  it {should respond_to :photo_file_size}
  it {should respond_to :photo_hash}
  it {should respond_to :title}
  it {should respond_to :user_id}
  it {should respond_to :photo_width}

  # associations
  it {should respond_to :user}

  # methods
  it {should respond_to :to_param}

  # scopes

  # carrierwave
  it {should respond_to :photo?}
  it {should respond_to :remove_photo}
  it {should respond_to :remove_photo!}

  describe 'properties' do
    it {Photo.new.attribution.should be_blank}
    it {Photo.new.description.should be_blank}
    it {Photo.new.photo_height.should be_blank}
    it {Photo.new.imageable_id.should be_blank}
    it {Photo.new.imageable_type.should be_blank}
    it {Photo.new.photo.should be_blank}

    describe 'photo_content_type' do
      it {Photo.new.photo_content_type.should be_blank}

      it 'should be populated after save' do
        FactoryGirl.create(:photo).photo_content_type.should_not be_blank
      end
    end
    
    describe 'photo_file_size' do
      it {Photo.new.photo_file_size.should be_blank}
      it {FactoryGirl.build(:photo).photo_file_size.should be_blank}

      it 'should be populated after save' do
        FactoryGirl.create(:photo).photo_file_size.should_not be_blank
      end
    end
    
    it {Photo.new.photo_hash.should be_blank}

    describe 'title' do
      it {Photo.new.title.should be_blank}

      it 'should populate with photo name if empty' do
        FactoryGirl.create(:photo).title.should_not be_blank
      end
    end

    it {Photo.new.user_id.should be_blank}

    describe 'width' do
      it {Photo.new.photo_width.should be_blank}

      it 'should populate from photo' do
        FactoryGirl.create(:photo).photo_width.should_not be_blank
      end
    end
  end

  describe 'validations' do
    it {Photo.new(@attr.merge(:attribution => '')).should be_valid}
    it {Photo.new(@attr.merge(:attribution => 'a'*256)).should_not be_valid}
    it {Photo.new(@attr.merge(:description => '')).should be_valid}
    it {Photo.new(@attr.merge(:description => 'a'*256)).should be_valid}
    it {Photo.new(@attr.merge(:imageable_id => '')).should be_valid}
    it {Photo.new(@attr.merge(:imageable_id => 'a')).should_not be_valid}
    it {Photo.new(@attr.merge(:imageable_type => '')).should be_valid}
    it {Photo.new(@attr.merge(:imageable_type => 'a'*256)).should_not be_valid}
    it {Photo.new(@attr.merge(:photo => '')).should_not be_valid}
    it {Photo.new(@attr.merge(:photo_content_type => '')).should_not be_valid}
    it {Photo.new(@attr.merge(:photo_content_type => 'a'*256)).should_not be_valid}
    # photo_file_size gets overridden by PhotoObserver
    it {Photo.new(@attr.merge(:photo_file_size => '')).should be_valid}
    it {Photo.new(@attr.merge(:photo_file_size => 'a')).should be_valid}

    describe 'photo_hash' do
      # photo_hash gets overridden by PhotoObserver
      it {Photo.new(@attr.merge(:photo_hash => '')).should be_valid}
      it {Photo.new(@attr.merge(:photo_hash => 'a'*256)).should be_valid}

      it 'should be unique' do
        @photo = FactoryGirl.create :photo
        FactoryGirl.build(:photo).should_not be_valid
      end
    end

    it {Photo.new(@attr.merge(:title => '')).should be_valid}
    it {Photo.new(@attr.merge(:title => 'a'*256)).should_not be_valid}
    it {Photo.new(@attr.merge(:user_id => '')).should_not be_valid}
    it {Photo.new(@attr.merge(:user_id => 'a')).should_not be_valid}
  end

  describe 'methods' do
    it 'should set title in to_param' do
      @photo = FactoryGirl.create(:photo)
      @photo.to_param.should eq "#{@photo.id}-#{@photo.title.parameterize}"
    end
  end

  describe 'scopes' do
    describe 'default' do
      it 'should order by id desc' do
        @a = FactoryGirl.create :photo
        @b = FactoryGirl.create :photo
        @c = FactoryGirl.create :photo
        Photo.all.should eq [@c, @b, @a]
      end
    end
  end
end
