class PagesController < ApplicationController
  load_and_authorize_resource
  before_filter :set_redirect, :only => [:edit]
  before_filter :lock, :only => [:edit, :update, :destroy]
  after_filter :unlock, :only => [:edit, :update]

  # GET /pages
  # GET /pages.json
  def index
    @pages = Page.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    @page = Page.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.json
  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page.revisions.build(:content => (@page.current_revision.nil? ? '' : @page.current_revision.content))
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = current_user.pages.build(params[:page])

    respond_to do |format|
      if @page.save
        format.html { redirect_to edit_page_path(@page), notice: 'Page was successfully created.' }
        format.json { render json: @page, status: :created, location: @page }
      else
        format.html { render action: "new" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.json
  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to (session[:redirect_to] || @page), notice: 'Page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to pages_url }
      format.json { head :no_content }
    end
  end

  private

    def set_redirect
      session[:redirect_to] = request.referrer
    end

    def lock
      if @page.locked?
        redirect_to((session[:redirect_to] || @page), :alert => "This page is currently being edited by #{@page.editor.name}.") unless @page.editor == current_user
      else
        @page.lock(current_user)
      end
    end

    def unlock
      @page.unlock
    end

end
