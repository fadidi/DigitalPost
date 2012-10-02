class WorkZonesController < ApplicationController
  load_and_authorize_resource

  # GET /work_zones
  # GET /work_zones.json
  def index
    @work_zones = WorkZone.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @work_zones }
    end
  end

  # GET /work_zones/1
  # GET /work_zones/1.json
  def show
    @work_zone = WorkZone.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @work_zone }
    end
  end

  # GET /work_zones/new
  # GET /work_zones/new.json
  def new
    @work_zone = WorkZone.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @work_zone }
    end
  end

  # GET /work_zones/1/edit
  def edit
    @work_zone = WorkZone.find(params[:id])
  end

  # POST /work_zones
  # POST /work_zones.json
  def create
    @work_zone = WorkZone.new(params[:work_zone])

    respond_to do |format|
      if @work_zone.save
        format.html { redirect_to @work_zone, notice: 'Work zone was successfully created.' }
        format.json { render json: @work_zone, status: :created, location: @work_zone }
      else
        format.html { render action: "new" }
        format.json { render json: @work_zone.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /work_zones/1
  # PUT /work_zones/1.json
  def update
    @work_zone = WorkZone.find(params[:id])

    respond_to do |format|
      if @work_zone.update_attributes(params[:work_zone])
        format.html { redirect_to @work_zone, notice: 'Work zone was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @work_zone.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /work_zones/1
  # DELETE /work_zones/1.json
  def destroy
    @work_zone = WorkZone.find(params[:id])
    @work_zone.destroy

    respond_to do |format|
      format.html { redirect_to work_zones_url }
      format.json { head :no_content }
    end
  end
end
