require 'spec_helper'

describe "References" do
  describe "GET /references" do
    it "should be successful" do
      get references_path
      response.status.should be(200)
    end
  end

  describe "GET /references/new" do
    it "should redirect" do
      get new_reference_path
      response.status.should be(302)
    end
  end
  
  describe "GET /references/1" do
    it "should be successful" do
      get references_path(:id => 1)
      response.status.should be(200)
    end
  end
  
  describe "POST /references" do
    it "should redirect" do
      post references_path
      response.status.should be(302)
    end
  end

  describe "GET /references/1/edit" do
    before :each do
      @reference = FactoryGirl.create :reference
    end

    it "should redirect" do
      get edit_reference_path @reference
      response.status.should be(302)
    end
  end
  
  describe "PUT /references/1" do
    before :each do
      @reference = FactoryGirl.create :reference
    end

    it "should redirect" do
      put reference_path @reference
      response.status.should be(302)
    end
  end
  
  describe "DELETE /references/1" do
    before :each do
      @reference = FactoryGirl.create :reference
    end

    it "should redirect" do
      delete reference_path @reference
      response.status.should be(302)
    end
  end
end
