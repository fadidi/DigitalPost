require "spec_helper"

describe VolunteersController do
  describe "routing" do

    it "routes to #index" do
      get("/volunteers").should route_to("volunteers#index")
    end

    it "routes to #show" do
      get("/volunteers/1").should route_to("users#show", :id => "1")
    end

    it "routes to #create" do
      post("/volunteers").should route_to("volunteers#create")
    end

    it "routes to #destroy" do
      delete("/volunteers/1").should route_to("volunteers#destroy", :id => "1")
    end

  end
end
