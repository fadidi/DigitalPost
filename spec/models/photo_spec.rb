require 'spec_helper'

describe Photo do
  before :each do
    @attr = {
      :title => 'Test Photo',
      :photo => 'photo',
      :height => 1,
      :width => 1,
      :user_id => 1,
      :photo_file_size => 1,
      :photo_content_type => 'test',
      :photo_hash => 'sthoeua'
    }
  end

  it {Photo.create! @attr}
  
  # properties
  it {should respond_to :attribution}
  it {should respond_to :description}
  it {should respond_to :height}
  it {should respond_to :imageable_id}
  it {should respond_to :imageable_type}
  it {should respond_to :photo}
  it {should respond_to :photo_content_type}
  it {should respond_to :photo_file_size}
  it {should respond_to :photo_hash}
  it {should respond_to :title}
  it {should respond_to :user_id}
  it {should respond_to :width}

  # associations

  describe 'properties' do
    it {Photo.new.attribution.should be_blank}
    it {Photo.new.description.should be_blank}
    it {Photo.new.height.should be_blank}
    it {Photo.new.imageable_id.should be_blank}
    it {Photo.new.imageable_type.should be_blank}
    it {Photo.new.photo.should be_blank}
    it {Photo.new.photo_content_type.should be_blank}
    it {Photo.new.photo_file_size.should be_blank}
    it {Photo.new.photo_hash.should be_blank}
    it {Photo.new.title.should be_blank}
    it {Photo.new.user_id.should be_blank}
    it {Photo.new.width.should be_blank}
  end

  describe 'validations' do
    it {Photo.new(@attr.merge(:attribution => '')).should be_valid}
    it {Photo.new(@attr.merge(:attribution => 'a'*256)).should_not be_valid}
    it {Photo.new(@attr.merge(:description => '')).should be_valid}
    it {Photo.new(@attr.merge(:description => 'a'*256)).should be_valid}
    it {Photo.new(@attr.merge(:height => '')).should_not be_valid}
    it {Photo.new(@attr.merge(:height => 'a')).should_not be_valid}
    it {Photo.new(@attr.merge(:imageable_id => '')).should be_valid}
    it {Photo.new(@attr.merge(:imageable_id => 'a')).should_not be_valid}
    it {Photo.new(@attr.merge(:imageable_type => '')).should be_valid}
    it {Photo.new(@attr.merge(:imageable_type => 'a'*256)).should_not be_valid}
    it {Photo.new(@attr.merge(:photo => '')).should_not be_valid}
    it {Photo.new(@attr.merge(:photo_content_type => '')).should_not be_valid}
    it {Photo.new(@attr.merge(:photo_content_type => 'a'*256)).should_not be_valid}
    it {Photo.new(@attr.merge(:photo_file_size => '')).should_not be_valid}
    it {Photo.new(@attr.merge(:photo_file_size => 'a')).should_not be_valid}
    it {Photo.new(@attr.merge(:photo_hash => '')).should_not be_valid}
    it {Photo.new(@attr.merge(:photo_hash => 'a'*256)).should_not be_valid}
    it {Photo.new(@attr.merge(:title => '')).should be_valid}
    it {Photo.new(@attr.merge(:title => 'a'*256)).should_not be_valid}
    it {Photo.new(@attr.merge(:user_id => '')).should_not be_valid}
    it {Photo.new(@attr.merge(:user_id => 'a')).should_not be_valid}
    it {Photo.new(@attr.merge(:width => '')).should_not be_valid}
    it {Photo.new(@attr.merge(:width => 'a')).should_not be_valid}
  end
end
