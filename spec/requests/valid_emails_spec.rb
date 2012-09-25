require 'spec_helper'

describe "ValidEmails" do
  describe "GET /valid_emails" do
    it "should be successful" do
      get valid_emails_path
      response.status.should be(302)
    end
  end

  describe "GET /valid_emails/new" do
    it "should redirect" do
      get new_valid_email_path
      response.status.should be(302)
    end
  end
  
  describe "GET /valid_emails/1" do
    it "should be successful" do
      get valid_emails_path(:id => 1)
      response.status.should be(302)
    end
  end
  
  describe "POST /valid_emails" do
    it "should redirect" do
      post valid_emails_path
      response.status.should be(302)
    end
  end

  describe "GET /valid_emails/1/edit" do
    before :each do
      @valid_email = FactoryGirl.create :valid_email
    end

    it "should redirect" do
      get edit_valid_email_path @valid_email
      response.status.should be(302)
    end
  end
  
  describe "PUT /valid_emails/1" do
    before :each do
      @valid_email = FactoryGirl.create :valid_email
    end

    it "should redirect" do
      put valid_email_path @valid_email
      response.status.should be(302)
    end
  end
  
  describe "DELETE /valid_emails/1" do
    before :each do
      @valid_email = FactoryGirl.create :valid_email
    end

    it "should redirect" do
      delete valid_email_path @valid_email
      response.status.should be(302)
    end
  end
end
