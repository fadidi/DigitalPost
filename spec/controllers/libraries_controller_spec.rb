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

describe LibrariesController do
  render_views

  # This should return the minimal set of attributes required to create a valid
  # Library. As you add validations to Library, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
      :name => 'test',
      :owner_id => 1
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # LibrariesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all libraries as @libraries" do
      library = Library.create! valid_attributes
      get :index, {}
      assigns(:libraries).should eq([library])
    end
  end

  describe "GET show" do
    it "assigns the requested library as @library" do
      library = Library.create! valid_attributes
      get :show, {:id => library.to_param}
      assigns(:library).should eq(library)
    end
  end

  describe "GET new" do
    login_admin
    it "assigns a new library as @library" do
      get :new, {}
      assigns(:library).should be_a_new(Library)
    end
  end

  describe "GET edit" do
    login_admin
    it "assigns the requested library as @library" do
      library = Library.create! valid_attributes
      get :edit, {:id => library.to_param}
      assigns(:library).should eq(library)
    end
  end

  describe "POST create" do
    login_admin
    describe "with valid params" do
      it "creates a new Library" do
        expect {
          post :create, {:library => valid_attributes}
        }.to change(Library, :count).by(1)
      end

      it "assigns a newly created library as @library" do
        post :create, {:library => valid_attributes}
        assigns(:library).should be_a(Library)
        assigns(:library).should be_persisted
      end

      it "redirects to the created library" do
        post :create, {:library => valid_attributes}
        response.should redirect_to(Library.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved library as @library" do
        # Trigger the behavior that occurs when invalid params are submitted
        Library.any_instance.stub(:save).and_return(false)
        post :create, {:library => {}}
        assigns(:library).should be_a_new(Library)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Library.any_instance.stub(:save).and_return(false)
        post :create, {:library => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    login_admin
    describe "with valid params" do
      it "updates the requested library" do
        library = Library.create! valid_attributes
        # Assuming there are no other libraries in the database, this
        # specifies that the Library created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Library.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => library.to_param, :library => {'these' => 'params'}}
      end

      it "assigns the requested library as @library" do
        library = Library.create! valid_attributes
        put :update, {:id => library.to_param, :library => valid_attributes}
        assigns(:library).should eq(library)
      end

      it "redirects to the library" do
        library = Library.create! valid_attributes
        put :update, {:id => library.to_param, :library => valid_attributes}
        response.should redirect_to(library)
      end
    end

    describe "with invalid params" do
      it "assigns the library as @library" do
        library = Library.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Library.any_instance.stub(:save).and_return(false)
        put :update, {:id => library.to_param, :library => {}}
        assigns(:library).should eq(library)
      end

      it "re-renders the 'edit' template" do
        library = Library.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Library.any_instance.stub(:save).and_return(false)
        put :update, {:id => library.to_param, :library => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    login_admin
    it "destroys the requested library" do
      library = Library.create! valid_attributes
      expect {
        delete :destroy, {:id => library.to_param}
      }.to change(Library, :count).by(-1)
    end

    it "redirects to the libraries list" do
      library = Library.create! valid_attributes
      delete :destroy, {:id => library.to_param}
      response.should redirect_to(libraries_path)
    end
  end

end
