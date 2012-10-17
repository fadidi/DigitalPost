require 'spec_helper'

describe "Timelines" do
  describe "GET /timelines" do
    it "should be successful" do
      get timelines_path
      response.status.should be(200)
    end
  end

  describe "GET /timelines/new" do
    it "should redirect" do
      get new_timeline_path
      response.status.should be(302)
    end
  end
  
  describe "GET /timelines/1" do
    it "should be successful" do
      get timelines_path(:id => 1)
      response.status.should be(200)
    end
  end
  
  describe "POST /timelines" do
    it "should redirect" do
      post timelines_path
      response.status.should be(302)
    end
  end

  describe "GET /timelines/1/edit" do
    before :each do
      @timeline = FactoryGirl.create :timeline
    end

    it "should redirect" do
      get edit_timeline_path @timeline
      response.status.should be(302)
    end
  end
  
  describe "PUT /timelines/1" do
    before :each do
      @timeline = FactoryGirl.create :timeline
    end

    it "should redirect" do
      put timeline_path @timeline
      response.status.should be(302)
    end
  end
  
  describe "DELETE /timelines/1" do
    before :each do
      @timeline = FactoryGirl.create :timeline
    end

    it "should redirect" do
      delete timeline_path @timeline
      response.status.should be(302)
    end
  end
end
