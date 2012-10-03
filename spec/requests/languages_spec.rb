require 'spec_helper'

describe "Languages" do
  describe "GET /languages" do
    it "should be successful" do
      get languages_path
      response.status.should be(200)
    end
  end

  describe "GET /languages/new" do
    it "should redirect" do
      get new_language_path
      response.status.should be(302)
    end
  end
  
  describe "GET /languages/1" do
    it "should be successful" do
      get languages_path(:id => 1)
      response.status.should be(200)
    end
  end
  
  describe "POST /languages" do
    it "should redirect" do
      post languages_path
      response.status.should be(302)
    end
  end

  describe "GET /languages/1/edit" do
    before :each do
      @language = FactoryGirl.create :language
    end

    it "should redirect" do
      get edit_language_path @language
      response.status.should be(302)
    end
  end
  
  describe "PUT /languages/1" do
    before :each do
      @language = FactoryGirl.create :language
    end

    it "should redirect" do
      put language_path @language
      response.status.should be(302)
    end
  end
  
  describe "DELETE /languages/1" do
    before :each do
      @language = FactoryGirl.create :language
    end

    it "should redirect" do
      delete language_path @language
      response.status.should be(302)
    end
  end
end
