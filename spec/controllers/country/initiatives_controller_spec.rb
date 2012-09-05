require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe Country::InitiativesController do
  before :each do
    ci = FactoryGirl.create :country_initiative
    @initiative = ci.initiative
    @country = ci.country
    @rando_initiative = FactoryGirl.create :initiative
  end

  describe "GET index" do
    it "assigns all associated initiatives as @initiatives" do
      get :index, { :country_code => @country.to_param }
      assigns(:initiatives).should eq([@initiative])
    end

    it "assigns current country as @country" do
      get :index, { :country_code => @country.to_param }
      assigns(:country).should eq(@country)
    end
  end

  describe "GET show" do
    it "assigns the requested initiative as @initiative" do
      get :show, {:id => @initiative.to_param, :country_code => @country.to_param}
      assigns(:initiative).should eq(@initiative)
    end
  end
end
