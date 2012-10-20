require 'spec_helper'

describe "Documents" do
  describe "GET /documents" do
    it "should be successful" do
      get documents_path
      response.status.should be(200)
    end
  end

  describe "GET /documents/new" do
    it "should redirect" do
      get new_document_path
      response.status.should be(302)
    end
  end
  
  describe "GET /documents/1" do
    it "should be successful" do
      get documents_path(:id => 1)
      response.status.should be(200)
    end
  end
  
  describe "POST /documents" do
    it "should redirect" do
      post documents_path
      response.status.should be(302)
    end
  end

  describe "GET /documents/1/edit" do
    before :each do
      @document = FactoryGirl.create :document
    end

    it "should redirect" do
      get edit_document_path @document
      response.status.should be(302)
    end
  end
  
  describe "PUT /documents/1" do
    before :each do
      @document = FactoryGirl.create :document
    end

    it "should redirect" do
      put document_path @document
      response.status.should be(302)
    end
  end
  
  describe "DELETE /documents/1" do
    before :each do
      @document = FactoryGirl.create :document
    end

    it "should redirect" do
      delete document_path @document
      response.status.should be(302)
    end
  end
end
