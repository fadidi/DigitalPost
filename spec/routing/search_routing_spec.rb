require "spec_helper"

describe SearchController do
  describe "routing" do

    it "routes to #index" do
      get('/search').should route_to("search#index")
    end
  end
end
