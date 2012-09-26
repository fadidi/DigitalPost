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

  # DELETE /volunteers/1
  # DELETE /volunteers/1.json
  def destroy
    user = User.find(params[:id])
    @volunteer = user.volunteer
    @volunteer.destroy

    respond_to do |format|
      format.html { redirect_to user }
      format.json { head :no_content }
    end
  end
end
