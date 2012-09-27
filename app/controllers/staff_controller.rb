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

  def create
    @staff = Staff.new(params[:staff])

    respond_to do |format|
      if @staff.save
        format.html { redirect_to user_path(@staff.user_id), notice: 'Staff member was successfully created.' }
        format.json { render json: @staff, status: :created, location: user_path(params[:staff][:user_id]) }
      else
        format.html { redirect_to users_path, notice: 'Staff member could not be created.' }
        format.json { render json: @staff.errors, status: :unprocessable_entity }
      end
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
