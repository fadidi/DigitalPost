class ReferencesController < ApplicationController
  load_and_authorize_resource

  # GET /references
  # GET /references.json
  def index
    @valid_references = Reference.valid
    @missing_references = Reference.missing
    @ambiguous_references = Reference.ambiguous

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @references }
    end
  end

  # GET /references/1
  # GET /references/1.json
  def show
    @reference = Reference.find(params[:id])
    search = Tire.search ELASTICSEARCH_INDEX do |search|
      search.query do |query|
        query.string @reference.link_text
      end
    end
    @results = search.results

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @reference }
    end
  end

  # GET /references/new
  # GET /references/new.json
  def new
    @reference = Reference.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reference }
    end
  end

  # GET /references/1/edit
  def edit
    @reference = Reference.find(params[:id])
  end

  # POST /references
  # POST /references.json
  def create
    @reference = Reference.new(params[:reference])

    respond_to do |format|
      if @reference.save
        format.html { redirect_to @reference, notice: 'Reference was successfully created.' }
        format.json { render json: @reference, status: :created, location: @reference }
      else
        format.html { render action: "new" }
        format.json { render json: @reference.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /references/1
  # PUT /references/1.json
  def update
    @reference = Reference.find(params[:id])

    respond_to do |format|
      if @reference.update_attributes(params[:reference])
        format.html { redirect_to @reference, notice: 'Reference was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @reference.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /references/1
  # DELETE /references/1.json
  def destroy
    @reference = Reference.find(params[:id])
    @reference.destroy

    respond_to do |format|
      format.html { redirect_to references_url }
      format.json { head :no_content }
    end
  end
end
