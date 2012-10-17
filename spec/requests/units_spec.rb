require 'spec_helper'

describe "Units" do
  describe "GET /units" do
    it "should redirect" do
      get units_path
      response.status.should be(302)
    end
  end

  describe "GET /units/new" do
    it "should redirect" do
      get new_unit_path
      response.status.should be(302)
    end
  end
  
  describe "GET /units/1" do
    it "should redirect" do
      get units_path(:id => 1)
      response.status.should be(302)
    end
  end
  
  describe "POST /units" do
    it "should redirect" do
      post units_path
      response.status.should be(302)
    end
  end

  describe "GET /units/1/edit" do
    before :each do
      @unit = FactoryGirl.create :unit
    end

    it "should redirect" do
      get edit_unit_path @unit
      response.status.should be(302)
    end
  end
  
  describe "PUT /units/1" do
    before :each do
      @unit = FactoryGirl.create :unit
    end

    it "should redirect" do
      put unit_path @unit
      response.status.should be(302)
    end
  end
  
  describe "DELETE /units/1" do
    before :each do
      @unit = FactoryGirl.create :unit
    end

    it "should redirect" do
      delete unit_path @unit
      response.status.should be(302)
    end
  end
end
