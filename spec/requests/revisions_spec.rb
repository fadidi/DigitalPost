require 'spec_helper'

describe "Revisions" do
  context 'nested under pages' do
    before :each do
      @page = FactoryGirl.create :page
    end

    describe "GET /revisions" do
      it "should be successful" do
        get page_revisions_path @page
        response.status.should be(200)
      end
    end

    describe "GET /revisions/1" do
      it "should be successful" do
        get page_revisions_path @page
        response.status.should be(200)
      end
    end
  end
  
  describe "DELETE /revisions/1" do
    before :each do
      @revision = FactoryGirl.create :revision
    end

    it "should redirect" do
      delete revision_path @revision
      response.status.should be(302)
    end
  end
end
