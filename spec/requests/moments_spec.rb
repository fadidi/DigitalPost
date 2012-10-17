require 'spec_helper'

describe "Moments" do
  describe "GET /moments" do
    it "should be successful" do
      get moments_path
      response.status.should be(200)
    end
  end

  describe "GET /moments/new" do
    it "should redirect" do
      get new_moment_path
      response.status.should be(302)
    end
  end
  
  describe "GET /moments/1" do
    it "should be successful" do
      get moments_path(:id => 1)
      response.status.should be(200)
    end
  end
  
  describe "POST /moments" do
    it "should redirect" do
      post moments_path
      response.status.should be(302)
    end
  end

  describe "GET /moments/1/edit" do
    before :each do
      @moment = FactoryGirl.create :moment
    end

    it "should redirect" do
      get edit_moment_path @moment
      response.status.should be(302)
    end
  end
  
  describe "PUT /moments/1" do
    before :each do
      @moment = FactoryGirl.create :moment
    end

    it "should redirect" do
      put moment_path @moment
      response.status.should be(302)
    end
  end
  
  describe "DELETE /moments/1" do
    before :each do
      @moment = FactoryGirl.create :moment
    end

    it "should redirect" do
      delete moment_path @moment
      response.status.should be(302)
    end
  end
end
