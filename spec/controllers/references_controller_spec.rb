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

describe ReferencesController do

  # This should return the minimal set of attributes required to create a valid
  # Reference. As you add validations to Reference, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
      :link_text => 'test text',
      :link_source_id => 1,
      :link_source_type => 'Page'
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ReferencesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  login_admin

  describe "GET index" do
    it "assigns all references as @references" do
      reference = Reference.create! valid_attributes
      get :index, {}
      assigns(:references).should eq([reference])
    end
  end

  describe "GET show" do
    it "assigns the requested reference as @reference" do
      reference = Reference.create! valid_attributes
      get :show, {:id => reference.to_param}
      assigns(:reference).should eq(reference)
    end
  end

  describe "GET new" do

    it "assigns a new reference as @reference" do
      get :new, {}
      assigns(:reference).should be_a_new(Reference)
    end
  end

  describe "GET edit" do

    it "assigns the requested reference as @reference" do
      reference = Reference.create! valid_attributes
      get :edit, {:id => reference.to_param}
      assigns(:reference).should eq(reference)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "creates a new Reference" do
        expect {
          post :create, {:reference => valid_attributes}
        }.to change(Reference, :count).by(1)
      end

      it "assigns a newly created reference as @reference" do
        post :create, {:reference => valid_attributes}
        assigns(:reference).should be_a(Reference)
        assigns(:reference).should be_persisted
      end

      it "redirects to the created reference" do
        post :create, {:reference => valid_attributes}
        response.should redirect_to(Reference.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved reference as @reference" do
        # Trigger the behavior that occurs when invalid params are submitted
        Reference.any_instance.stub(:save).and_return(false)
        post :create, {:reference => {}}
        assigns(:reference).should be_a_new(Reference)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Reference.any_instance.stub(:save).and_return(false)
        post :create, {:reference => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested reference" do
        reference = Reference.create! valid_attributes
        # Assuming there are no other references in the database, this
        # specifies that the Reference created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Reference.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => reference.to_param, :reference => {'these' => 'params'}}
      end

      it "assigns the requested reference as @reference" do
        reference = Reference.create! valid_attributes
        put :update, {:id => reference.to_param, :reference => valid_attributes}
        assigns(:reference).should eq(reference)
      end

      it "redirects to the reference" do
        reference = Reference.create! valid_attributes
        put :update, {:id => reference.to_param, :reference => valid_attributes}
        response.should redirect_to(reference)
      end
    end

    describe "with invalid params" do
      it "assigns the reference as @reference" do
        reference = Reference.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Reference.any_instance.stub(:save).and_return(false)
        put :update, {:id => reference.to_param, :reference => {}}
        assigns(:reference).should eq(reference)
      end

      it "re-renders the 'edit' template" do
        reference = Reference.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Reference.any_instance.stub(:save).and_return(false)
        put :update, {:id => reference.to_param, :reference => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do

    it "destroys the requested reference" do
      reference = Reference.create! valid_attributes
      expect {
        delete :destroy, {:id => reference.to_param}
      }.to change(Reference, :count).by(-1)
    end

    it "redirects to the references list" do
      reference = Reference.create! valid_attributes
      delete :destroy, {:id => reference.to_param}
      response.should redirect_to(references_path)
    end
  end

end
