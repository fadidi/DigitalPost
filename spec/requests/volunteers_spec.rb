require 'spec_helper'

describe "Volunteers" do
  describe "GET /volunteers" do
    it "should be successful" do
      get volunteers_path
      response.status.should be(302)
    end
  end

  describe "DELETE /volunteers/1" do
    before :each do
      @volunteer = FactoryGirl.create :volunteer
    end

    it "should redirect" do
      delete volunteer_path @volunteer
      response.status.should be(302)
    end
  end  
end
