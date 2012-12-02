require 'spec_helper'

describe "Libraries" do
  describe "GET /libraries" do
    it "should be successful" do
      get libraries_path
      response.status.should be(200)
    end
  end

  describe "GET /libraries/new" do
    it "should redirect" do
      get new_library_path
      response.status.should be(302)
    end
  end
  
  describe "GET /libraries/1" do
    it "should be successful" do
      get libraries_path(:id => 1)
      response.status.should be(200)
    end
  end
  
  describe "POST /libraries" do
    it "should redirect" do
      post libraries_path
      response.status.should be(302)
    end
  end

  describe "GET /libraries/1/edit" do
    before :each do
      @library = FactoryGirl.create :library
    end

    it "should redirect" do
      get edit_library_path @library
      response.status.should be(302)
    end
  end
  
  describe "PUT /libraries/1" do
    before :each do
      @library = FactoryGirl.create :library
    end

    it "should redirect" do
      put library_path @library
      response.status.should be(302)
    end
  end
  
  describe "DELETE /libraries/1" do
    before :each do
      @library = FactoryGirl.create :library
    end

    it "should redirect" do
      delete library_path @library
      response.status.should be(302)
    end
  end
end
