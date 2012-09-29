require "spec_helper"

describe HomeController do
  describe "routing" do

    pending "routes to #index" do
      get(root_path).should route_to("home#index")
    end

    it "routes to #search" do
      get("/search").should route_to("home#search")
    end
  end
end
