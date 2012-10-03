require 'spec_helper'

describe "Sectors" do
  describe "GET /sectors" do
    it "should be successful" do
      get sectors_path
      response.status.should be(302)
    end
  end

  describe "GET /sectors/new" do
    it "should redirect" do
      get new_sector_path
      response.status.should be(302)
    end
  end
  
  describe "GET /sectors/1" do
    it "should be successful" do
      get sectors_path(:id => 1)
      response.status.should be(302)
    end
  end
  
  describe "POST /sectors" do
    it "should redirect" do
      post sectors_path
      response.status.should be(302)
    end
  end

  describe "GET /sectors/1/edit" do
    before :each do
      @sector = FactoryGirl.create :sector
    end

    it "should redirect" do
      get edit_sector_path @sector
      response.status.should be(302)
    end
  end
  
  describe "PUT /sectors/1" do
    before :each do
      @sector = FactoryGirl.create :sector
    end

    it "should redirect" do
      put sector_path @sector
      response.status.should be(302)
    end
  end
  
  describe "DELETE /sectors/1" do
    before :each do
      @sector = FactoryGirl.create :sector
    end

    it "should redirect" do
      delete sector_path @sector
      response.status.should be(302)
    end
  end
end
