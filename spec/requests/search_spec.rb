require 'spec_helper'

describe "Home" do
  describe "GET /search" do
    it "should be successful" do
      get '/search'
      response.status.should be(200)
    end
  end
end
