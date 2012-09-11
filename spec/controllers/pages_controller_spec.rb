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

describe PagesController do

  # This should return the minimal set of attributes required to create a valid
  # Page. As you add validations to Page, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
      :title => 'Test Title',
      :country_id => 1
    }
  end

  def valid_revision_attributes
    {
      :content => 'Some fun, fresh content',
      :author_id => 1
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PagesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all pages as @pages" do
      page = Page.create! valid_attributes
      get :index, {}
      assigns(:pages).should eq([page])
    end
  end

  describe "GET show" do
    it "assigns the requested page as @page" do
      page = Page.create! valid_attributes
      get :show, {:id => page.to_param}
      assigns(:page).should eq(page)
    end
  end

  describe "GET new" do
    login_admin
    it "assigns a new page as @page" do
      get :new, {}
      assigns(:page).should be_a_new(Page)
    end
  end

  describe "GET edit" do
    login_admin
    before :each do
      @page = FactoryGirl.create :page
    end

    it "assigns the requested page as @page" do
      page = Page.create! valid_attributes
      get :edit, {:id => page.to_param}
      assigns(:page).should eq(page)
    end

    pending 'should set session[:redirect_to]' do
      page = Page.create! valid_attributes
      get :edit, {:id => page.to_param}, {'HTTP_REFERRER' => 'http://alphatest.com'}
      response.env['rack.session'][:redirect_to].should =~ /http:\/\/alphatest.com/i
    end

    describe 'unlocked' do
      it 'should be successful' do
        get :edit, :id => @page.to_param
        response.should be_success
      end

      it 'should lock the page' do
        get :edit, :id => @page.to_param
        @page.reload.locked?.should be_true
      end

      it 'should build a revision' do
        get :edit, :id => @page.to_param
        assigns(:page).should have(1).revisions
      end

      describe 'revision' do
        it 'should set the content blank if no prior revision' do
          get :edit, :id => @page.to_param
          assigns(:page).revisions.first.content.should be_blank
        end

        it 'should set content equal to prior revision if prior revision' do
          @revision = FactoryGirl.create(:revision, :page => @page)
          get :edit, :id => @page.to_param
          assigns(:page).revisions.first.content.should eq @revision.content
        end
      end
    end

    describe 'locked' do
      before :each do
        @page.lock(FactoryGirl.create(:user))
      end

      context 'not as current editor' do
        it 'should redirect to the page if session[:redirect_to] is not set' do
          get :edit, :id => @page.to_param
          response.should redirect_to @page
        end

        pending 'should not redirect to @page if redirect is set' do
          country = FactoryGirl.create(:country)
          get :edit, {:id => @page.to_param}, {'HTTP_REFERRER' => country_url(country)}
          response.should_not redirect_to @page
        end

        pending 'should redirect to session[:redirect_to] if set' do
          country = FactoryGirl.create(:country)
          get :edit, {:id => @page.to_param}, {'HTTP_REFERRER' => country_url(country)}
          response.should redirect_to(country_url(country))
        end
      end

      context 'as current editor' do
        before :each do
          @page.lock(@admin)
        end

        it 'renders the edit view if current_user is editor' do
          get :edit, :id => @page.to_param
          response.should be_success
        end
      end
    end
  end

  describe "POST create" do
    login_admin
    describe "with valid params" do
      it "creates a new Page" do
        expect {
          post :create, {:page => valid_attributes}
        }.to change(Page, :count).by(1)
      end

      it "assigns a newly created page as @page" do
        post :create, {:page => valid_attributes}
        assigns(:page).should be_a(Page)
        assigns(:page).should be_persisted
      end

      it "redirects to the new page" do
        post :create, {:page => valid_attributes}
        response.should redirect_to edit_page_path(assigns(:page))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved page as @page" do
        # Trigger the behavior that occurs when invalid params are submitted
        Page.any_instance.stub(:save).and_return(false)
        post :create, {:page => {}}
        assigns(:page).should be_a_new(Page)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Page.any_instance.stub(:save).and_return(false)
        post :create, {:page => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    before :each do
      @page = FactoryGirl.create :page
    end
    login_admin

    describe "with valid params" do
      it "updates the requested page" do
        updated_at = @page.updated_at
        put :update, :id => @page.to_param, :page => valid_attributes
        assigns(:page).updated_at.should be > updated_at
      end

      it "assigns the requested page as @page" do
        page = Page.create! valid_attributes
        put :update, {:id => page.to_param, :page => valid_attributes}
        assigns(:page).should eq(page)
      end

      it "redirects to the page by default" do
        page = Page.create! valid_attributes
        put :update, {:id => page.to_param, :page => valid_attributes}
        response.should redirect_to(page)
      end

      it 'redirects to a session[:redirect_to] if present' do
        @country = FactoryGirl.create(:country)
        session[:redirect_to] = country_path(@country)
        page = Page.create! valid_attributes
        put :update, :id => page.to_param
        response.should redirect_to(country_path(@country))
      end

      context 'no current revisions' do
        it 'should create a new revision' do
          lambda do
            put :update, :id => @page.id, :page => valid_attributes.merge(:revisions_attributes => [valid_revision_attributes])
          end.should change(Revision, :count).by(1)
        end
      end
      
      context 'with current revisions' do
        before :each do
          @revision = FactoryGirl.create(:revision, :page => @page)
        end

        it 'should create a new revision if revised' do
          lambda do
            put :update, :id => @page.id, :page => valid_attributes.merge(:revisions_attributes => [valid_revision_attributes.merge(:content => @revision.content + ' new')])
          end.should change(Revision, :count).by(1)
        end

        pending 'should not create a new revision if unrevised' do
          lambda do
            put :update, :id => @page.to_param, :page => valid_attributes.merge(:revisions_attributes => [valid_revision_attributes.merge(:content => @revision.content)])
          end.should_not change(Revision, :count).by(1)
        end
      end
    end

    describe "with invalid params" do
      it "assigns the page as @page" do
        page = Page.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Page.any_instance.stub(:save).and_return(false)
        put :update, {:id => page.to_param, :page => {}}
        assigns(:page).should eq(page)
      end

      it "re-renders the 'edit' template" do
        page = Page.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Page.any_instance.stub(:save).and_return(false)
        put :update, {:id => page.to_param, :page => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    login_admin
    it "destroys the requested page" do
      page = Page.create! valid_attributes
      expect {
        delete :destroy, {:id => page.to_param}
      }.to change(Page, :count).by(-1)
    end

    it "redirects to the pages list" do
      page = Page.create! valid_attributes
      delete :destroy, {:id => page.to_param}
      response.should redirect_to(pages_url)
    end
  end

end
