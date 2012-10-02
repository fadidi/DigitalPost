require "spec_helper"

describe WorkZonesController do
  describe "routing" do

    it "routes to #index" do
      get("/work_zones").should route_to("work_zones#index")
    end

    it "routes to #new" do
      get("/work_zones/new").should route_to("work_zones#new")
    end

    it "routes to #show" do
      get("/work_zones/1").should route_to("work_zones#show", :id => "1")
    end

    it "routes to #edit" do
      get("/work_zones/1/edit").should route_to("work_zones#edit", :id => "1")
    end

    it "routes to #create" do
      post("/work_zones").should route_to("work_zones#create")
    end

    it "routes to #update" do
      put("/work_zones/1").should route_to("work_zones#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/work_zones/1").should route_to("work_zones#destroy", :id => "1")
    end

  end
end
