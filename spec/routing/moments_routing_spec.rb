require "spec_helper"

describe MomentsController do
  describe "routing" do

    it "routes to #index" do
      get("/moments").should route_to("moments#index")
    end

    it "routes to #new" do
      get("/moments/new").should route_to("moments#new")
    end

    it "routes to #show" do
      get("/moments/1").should route_to("moments#show", :id => "1")
    end

    it "routes to #edit" do
      get("/moments/1/edit").should route_to("moments#edit", :id => "1")
    end

    it "routes to #create" do
      post("/moments").should route_to("moments#create")
    end

    it "routes to #update" do
      put("/moments/1").should route_to("moments#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/moments/1").should route_to("moments#destroy", :id => "1")
    end

  end
end
