require 'spec_helper'

describe Photo do
  before :each do
    @attr = {
      :title => 'Test Photo'
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
    it {Photo.new.title.should be_blank}
    it {Photo.new.user_id.should be_blank}
    it {Photo.new.width.should be_blank}
  end

  describe 'validations' do
    it {Photo.new(@attr.merge(:attribution => '')).should be_valid}
  end
end
