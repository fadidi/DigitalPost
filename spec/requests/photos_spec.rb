require 'spec_helper'

describe "Photos" do
  describe "GET /photos" do
    it "should be successful" do
      get photos_path
      response.status.should be(200)
    end
  end

  describe "GET /photos/new" do
    it "should redirect" do
      get new_photo_path
      response.status.should be(302)
    end
  end
  
  describe "GET /photos/1" do
    it "should be successful" do
      get photos_path(:id => 1)
      response.status.should be(200)
    end
  end
  
  describe "POST /photos" do
    it "should redirect" do
      post photos_path
      response.status.should be(302)
    end
  end

  describe "GET /photos/1/edit" do
    before :each do
      @photo = FactoryGirl.create :photo
    end

    it "should redirect" do
      get edit_photo_path @photo
      response.status.should be(302)
    end
  end
  
  describe "PUT /photos/1" do
    before :each do
      @photo = FactoryGirl.create :photo
    end

    it "should redirect" do
      put photo_path @photo
      response.status.should be(302)
    end
  end
  
  describe "DELETE /photos/1" do
    before :each do
      @photo = FactoryGirl.create :photo
    end

    it "should redirect" do
      delete photo_path @photo
      response.status.should be(302)
    end
  end
end
