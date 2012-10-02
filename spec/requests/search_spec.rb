require 'spec_helper'

describe "Home" do
  describe "GET /" do
    it "should be successful" do
      get root_path
      response.status.should be(200)
    end
  end
end
