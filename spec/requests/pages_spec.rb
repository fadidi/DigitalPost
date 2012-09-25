require 'spec_helper'

describe "Pages" do
  describe "GET /pages" do
    it "should be successful" do
      get pages_path
      response.status.should be(200)
    end
  end

  describe "GET /pages/new" do
    it "should redirect" do
      get new_page_path
      response.status.should be(302)
    end
  end
  
  describe "GET /pages/1" do
    it "should be successful" do
      get pages_path(:id => 1)
      response.status.should be(200)
    end
  end
  
  describe "POST /pages" do
    it "should redirect" do
      post pages_path
      response.status.should be(302)
    end
  end

  describe "GET /pages/1/edit" do
    before :each do
      @page = FactoryGirl.create :page
    end

    it "should redirect" do
      get edit_page_path @page
      response.status.should be(302)
    end
  end
  
  describe "PUT /pages/1" do
    before :each do
      @page = FactoryGirl.create :page
    end

    it "should redirect" do
      put page_path @page
      response.status.should be(302)
    end
  end
  
  describe "DELETE /pages/1" do
    before :each do
      @page = FactoryGirl.create :page
    end

    it "should redirect" do
      delete page_path @page
      response.status.should be(302)
    end
  end
end
