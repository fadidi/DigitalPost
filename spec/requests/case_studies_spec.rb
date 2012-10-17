require 'spec_helper'

describe "CaseStudies" do
  describe "GET /case_studies" do
    it "should be successful" do
      get case_studies_path
      response.status.should be(200)
    end
  end

  describe "GET /case_studies/new" do
    it "should redirect" do
      get new_case_study_path
      response.status.should be(302)
    end
  end
  
  describe "GET /case_studies/1" do
    it "should be successful" do
      get case_studies_path(:id => 1)
      response.status.should be(200)
    end
  end
  
  describe "POST /case_studies" do
    it "should redirect" do
      post case_studies_path
      response.status.should be(302)
    end
  end

  describe "GET /case_studies/1/edit" do
    before :each do
      @case_study = FactoryGirl.create :case_study
    end

    it "should redirect" do
      get edit_case_study_path @case_study
      response.status.should be(302)
    end
  end
  
  describe "PUT /case_studies/1" do
    before :each do
      @case_study = FactoryGirl.create :case_study
    end

    it "should redirect" do
      put case_study_path @case_study
      response.status.should be(302)
    end
  end
  
  describe "DELETE /case_studies/1" do
    before :each do
      @case_study = FactoryGirl.create :case_study
    end

    it "should redirect" do
      delete case_study_path @case_study
      response.status.should be(302)
    end
  end
end
