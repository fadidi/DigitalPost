require 'spec_helper'

describe "Staff" do
  describe "GET /staff" do
    it "should be successful" do
      get staff_index_path
      response.status.should be(302)
    end
  end

  describe 'POST /staff' do
    it 'should redirect' do
      post staff_index_path
      response.status.should be 302
    end
  end

  describe "DELETE /staff/1" do
    before :each do
      @staff = FactoryGirl.create :staff
    end

    it "should redirect" do
      delete staff_path @staff
      response.status.should be(302)
    end
  end  
end
