require 'spec_helper'

describe "WorkZones" do
  describe "GET /work_zones" do
    it "should be successful" do
      get work_zones_path
      response.status.should be(302)
    end
  end

  describe "GET /work_zones/new" do
    it "should redirect" do
      get new_work_zone_path
      response.status.should be(302)
    end
  end
  
  describe "GET /work_zones/1" do
    it "should be successful" do
      get work_zones_path(:id => 1)
      response.status.should be(302)
    end
  end
  
  describe "POST /work_zones" do
    it "should redirect" do
      post work_zones_path
      response.status.should be(302)
    end
  end

  describe "GET /work_zones/1/edit" do
    before :each do
      @work_zone = FactoryGirl.create :work_zone
    end

    it "should redirect" do
      get edit_work_zone_path @work_zone
      response.status.should be(302)
    end
  end
  
  describe "PUT /work_zones/1" do
    before :each do
      @work_zone = FactoryGirl.create :work_zone
    end

    it "should redirect" do
      put work_zone_path @work_zone
      response.status.should be(302)
    end
  end
  
  describe "DELETE /work_zones/1" do
    before :each do
      @work_zone = FactoryGirl.create :work_zone
    end

    it "should redirect" do
      delete work_zone_path @work_zone
      response.status.should be(302)
    end
  end
end
