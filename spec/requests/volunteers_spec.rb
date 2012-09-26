require 'spec_helper'

describe "Volunteers" do
  describe "GET /volunteers" do
    it "should be successful" do
      get volunteers_path
      response.status.should be(302)
    end
  end

  describe "GET /volunteers/new" do
    it "should redirect" do
      get new_volunteer_path
      response.status.should be(302)
    end
  end
  
  describe "GET /volunteers/1" do
    it "should be successful" do
      get volunteers_path(:id => 1)
      response.status.should be(302)
    end
  end
  
  describe "POST /volunteers" do
    it "should redirect" do
      post volunteers_path
      response.status.should be(302)
    end
  end

  describe "GET /volunteers/1/edit" do
    before :each do
      @volunteer = FactoryGirl.create :volunteer
    end

    it "should redirect" do
      get edit_volunteer_path @volunteer
      response.status.should be(302)
    end
  end
  
  describe "PUT /volunteers/1" do
    before :each do
      @volunteer = FactoryGirl.create :volunteer
    end

    it "should redirect" do
      put volunteer_path @volunteer
      response.status.should be(302)
    end
  end
  
  describe "DELETE /volunteers/1" do
    before :each do
      @volunteer = FactoryGirl.create :volunteer
    end

    it "should redirect" do
      delete volunteer_path @volunteer
      response.status.should be(302)
    end
  end  
end
