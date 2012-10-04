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

describe WorkZonesController do
  render_views

  # This should return the minimal set of attributes required to create a valid
  # WorkZone. As you add validations to WorkZone, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
      :abbreviation => 'ABC',
      :name => 'Test Work Zone',
      :region_id => 1
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # WorkZonesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  login_admin

  describe "GET index" do
    it "assigns all work_zones as @work_zones" do
      work_zone = FactoryGirl.create(:work_zone)
      get :index, {}
      assigns(:work_zones).should eq([work_zone])
    end
  end

  describe "GET show" do
    it "assigns the requested work_zone as @work_zone" do
      work_zone = FactoryGirl.create :work_zone
      get :show, {:id => work_zone.to_param}
      assigns(:work_zone).should eq(work_zone)
    end
  end

  describe "GET new" do
    it "assigns a new work_zone as @work_zone" do
      get :new, {}
      assigns(:work_zone).should be_a_new(WorkZone)
    end
  end

  describe "GET edit" do
    it "assigns the requested work_zone as @work_zone" do
      work_zone = FactoryGirl.create :work_zone
      get :edit, {:id => work_zone.to_param}
      assigns(:work_zone).should eq(work_zone)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      before :each do
        @attrs = FactoryGirl.attributes_for(:work_zone).merge(:region_id => FactoryGirl.create(:region).id)
      end

      it "creates a new WorkZone" do
        expect {
          post :create, :work_zone => @attrs
        }.to change(WorkZone, :count).by(1)
      end

      it "assigns a newly created work_zone as @work_zone" do
        post :create, {:work_zone => @attrs}
        assigns(:work_zone).should be_a(WorkZone)
        assigns(:work_zone).should be_persisted
      end

      it "redirects to the created work_zone" do
        post :create, {:work_zone => @attrs}
        response.should redirect_to(WorkZone.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved work_zone as @work_zone" do
        # Trigger the behavior that occurs when invalid params are submitted
        WorkZone.any_instance.stub(:save).and_return(false)
        post :create, {:work_zone => {}}
        assigns(:work_zone).should be_a_new(WorkZone)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        WorkZone.any_instance.stub(:save).and_return(false)
        post :create, {:work_zone => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    before :each do
      @attrs = FactoryGirl.attributes_for(:work_zone).merge(:region_id => FactoryGirl.create(:region).id)
      @work_zone = WorkZone.create! @attrs
    end

    describe "with valid params" do
      it "updates the requested work_zone" do
        # Assuming there are no other work_zones in the database, this
        # specifies that the WorkZone created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        #WorkZone.any_instance.should_receive(:update_attributes).with(@attrs.merge(:name => 'Spiffy New Zone'))
        put :update, {:id => @work_zone.to_param, :work_zone => @attrs.merge(:name => 'New TEST Name')}
        @work_zone.reload.name.should eq 'New TEST Name'
      end

      it "assigns the requested work_zone as @work_zone" do
        put :update, {:id => @work_zone.to_param, :work_zone => @attrs}
        assigns(:work_zone).should eq(@work_zone)
      end

      it "redirects to the work_zone" do
        put :update, {:id => @work_zone.to_param, :work_zone => @attrs}
        response.should redirect_to(@work_zone)
      end
    end

    describe "with invalid params" do
      it "assigns the work_zone as @work_zone" do
        put :update, {:id => @work_zone.to_param, :work_zone => {:name => ''}}
        assigns(:work_zone).should eq(@work_zone)
      end

      it "re-renders the 'edit' template" do
        put :update, {:id => @work_zone.to_param, :work_zone => {:name => ''}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before :each do
      @work_zone = FactoryGirl.create :work_zone
    end

    it "destroys the requested work_zone" do
      expect {
        delete :destroy, {:id => @work_zone.to_param}
      }.to change(WorkZone, :count).by(-1)
    end

    it "redirects to the work_zones list" do
      delete :destroy, {:id => @work_zone.to_param}
      response.should redirect_to(work_zones_path)
    end
  end

end