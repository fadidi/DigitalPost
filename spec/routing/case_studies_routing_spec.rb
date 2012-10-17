require "spec_helper"

describe CaseStudiesController do
  describe "routing" do

    it "routes to #index" do
      get("/case_studies").should route_to("case_studies#index")
    end

    it "routes to #new" do
      get("/case_studies/new").should route_to("case_studies#new")
    end

    it "routes to #show" do
      get("/case_studies/1").should route_to("case_studies#show", :id => "1")
    end

    it "routes to #edit" do
      get("/case_studies/1/edit").should route_to("case_studies#edit", :id => "1")
    end

    it "routes to #create" do
      post("/case_studies").should route_to("case_studies#create")
    end

    it "routes to #update" do
      put("/case_studies/1").should route_to("case_studies#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/case_studies/1").should route_to("case_studies#destroy", :id => "1")
    end

  end
end
