class StaffController < ApplicationController
  authorize_resource

  # GET /staff
  # GET /staff.json
  def index
    @staff = Staff.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @staff }
    end
  end

  # DELETE /staff/1
  # DELETE /staff/1.json
  def destroy
    user = User.find(params[:id])
    @staff = user.staff
    @staff.destroy

    respond_to do |format|
      format.html { redirect_to user_path(user) }
      format.json { head :no_content }
    end
  end
end
