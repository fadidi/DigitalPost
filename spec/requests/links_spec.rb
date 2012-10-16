require 'spec_helper'

describe "Links" do
  describe "GET /links" do
    it "should be successful" do
      get links_path
      response.status.should be(200)
    end
  end

  describe "GET /links/new" do
    it "should redirect" do
      get new_link_path
      response.status.should be(302)
    end
  end
  
  describe "GET /links/1" do
    it "should be successful" do
      get links_path(:id => 1)
      response.status.should be(200)
    end
  end
  
  describe "POST /links" do
    it "should redirect" do
      post links_path
      response.status.should be(302)
    end
  end

  describe "GET /links/1/edit" do
    before :each do
      @link = FactoryGirl.create :link
    end

    it "should redirect" do
      get edit_link_path @link
      response.status.should be(302)
    end
  end
  
  describe "PUT /links/1" do
    before :each do
      @link = FactoryGirl.create :link
    end

    it "should redirect" do
      put link_path @link
      response.status.should be(302)
    end
  end
  
  describe "DELETE /links/1" do
    before :each do
      @link = FactoryGirl.create :link
    end

    it "should redirect" do
      delete link_path @link
      response.status.should be(302)
    end
  end
end
