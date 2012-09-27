class VolunteersController < ApplicationController
  authorize_resource

  # GET /volunteers
  # GET /volunteers.json
  def index
    @volunteers = Volunteer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @volunteers }
    end
  end

  def create
    @volunteer = Volunteer.new(params[:volunteer])

    respond_to do |format|
      if @volunteer.save
        format.html { redirect_to user_path(@volunteer.user_id), notice: 'Volunteer was successfully created.' }
        format.js
      else
        format.html { redirect_to users_path, notice: 'Volunteer could not be created.' }
      end
    end
  end

  # DELETE /volunteers/1
  # DELETE /volunteers/1.json
  def destroy
    @volunteer = Volunteer.find(params[:id])
    @volunteer.destroy

    respond_to do |format|
      format.html { redirect_to @volunteer.user }
      format.js
    end
  end
end
