require 'spec_helper'

describe "Stages" do
  describe "GET /stages" do
    it "should be successful" do
      get stages_path
      response.status.should be(302)
    end
  end

  describe "GET /stages/new" do
    it "should redirect" do
      get new_stage_path
      response.status.should be(302)
    end
  end
  
  describe "GET /stages/1" do
    it "should be successful" do
      get stages_path(:id => 1)
      response.status.should be(302)
    end
  end
  
  describe "POST /stages" do
    it "should redirect" do
      post stages_path
      response.status.should be(302)
    end
  end

  describe "GET /stages/1/edit" do
    before :each do
      @stage = FactoryGirl.create :stage
    end

    it "should redirect" do
      get edit_stage_path @stage
      response.status.should be(302)
    end
  end
  
  describe "PUT /stages/1" do
    before :each do
      @stage = FactoryGirl.create :stage
    end

    it "should redirect" do
      put stage_path @stage
      response.status.should be(302)
    end
  end
  
  describe "DELETE /stages/1" do
    before :each do
      @stage = FactoryGirl.create :stage
    end

    it "should redirect" do
      delete stage_path @stage
      response.status.should be(302)
    end
  end
end
