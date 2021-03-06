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

describe DocumentsController do
  render_views

  # This should return the minimal set of attributes required to create a valid
  # Document. As you add validations to Document, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    FactoryGirl.attributes_for(:document).merge(:language_id => FactoryGirl.create(:language).id, :user_id => FactoryGirl.create(:user).id)
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DocumentsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all documents as @documents" do
      document = Document.create! valid_attributes
      get :index, {}
      assigns(:documents).should eq([document])
    end
  end

  describe "GET show" do
    it "assigns the requested document as @document" do
      document = Document.create! valid_attributes
      get :show, {:id => document.to_param}
      assigns(:document).should eq(document)
    end
  end

  describe "GET new" do
    login_admin
    it "assigns a new document as @document" do
      get :new, {}
      assigns(:document).should be_a_new(Document)
    end
  end

  describe "GET edit" do
    login_admin
    it "assigns the requested document as @document" do
      document = Document.create! valid_attributes
      get :edit, {:id => document.to_param}
      assigns(:document).should eq(document)
    end
  end

  describe "POST create" do
    login_admin
    describe "with valid params" do
      it "creates a new Document" do
        expect {
          post :create, {:document => valid_attributes}
        }.to change(Document, :count).by(1)
      end

      it "assigns a newly created document as @document" do
        post :create, {:document => valid_attributes}
        assigns(:document).should be_a(Document)
        assigns(:document).should be_persisted
      end

      it "redirects to the created document" do
        post :create, {:document => valid_attributes}
        response.should redirect_to(Document.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved document as @document" do
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        post :create, {:document => {}}
        assigns(:document).should be_a_new(Document)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        post :create, {:document => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    login_admin
    describe "with valid params" do
      it "updates the requested document" do
        document = Document.create! valid_attributes
        # Assuming there are no other documents in the database, this
        # specifies that the Document created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Document.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => document.to_param, :document => {'these' => 'params'}}
      end

      it "assigns the requested document as @document" do
        document = Document.create! valid_attributes
        put :update, {:id => document.to_param, :document => valid_attributes}
        assigns(:document).should eq(document)
      end

      it "redirects to the document" do
        document = Document.create! valid_attributes
        put :update, {:id => document.to_param, :document => valid_attributes}
        response.should redirect_to(document)
      end
    end

    describe "with invalid params" do
      it "assigns the document as @document" do
        document = Document.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        put :update, {:id => document.to_param, :document => {}}
        assigns(:document).should eq(document)
      end

      it "re-renders the 'edit' template" do
        document = Document.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        put :update, {:id => document.to_param, :document => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    login_admin
    it "destroys the requested document" do
      document = Document.create! valid_attributes
      expect {
        delete :destroy, {:id => document.to_param}
      }.to change(Document, :count).by(-1)
    end

    it "redirects to the documents list" do
      document = Document.create! valid_attributes
      delete :destroy, {:id => document.to_param}
      response.should redirect_to(documents_path)
    end
  end

end
