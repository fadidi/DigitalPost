require 'spec_helper'

describe "Regions" do
  describe "GET /regions" do
    it "should be successful" do
      get regions_path
      response.status.should be(302)
    end
  end

  describe "GET /regions/new" do
    it "should redirect" do
      get new_region_path
      response.status.should be(302)
    end
  end
  
  describe "GET /regions/1" do
    it "should be successful" do
      get regions_path(:id => 1)
      response.status.should be(302)
    end
  end
  
  describe "POST /regions" do
    it "should redirect" do
      post regions_path
      response.status.should be(302)
    end
  end

  describe "GET /regions/1/edit" do
    before :each do
      @region = FactoryGirl.create :region
    end

    it "should redirect" do
      get edit_region_path @region
      response.status.should be(302)
    end
  end
  
  describe "PUT /regions/1" do
    before :each do
      @region = FactoryGirl.create :region
    end

    it "should redirect" do
      put region_path @region
      response.status.should be(302)
    end
  end
  
  describe "DELETE /regions/1" do
    before :each do
      @region = FactoryGirl.create :region
    end

    it "should redirect" do
      delete region_path @region
      response.status.should be(302)
    end
  end
end
