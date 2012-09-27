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
        format.js
      else
        format.html { redirect_to users_path, notice: 'Staff member could not be created.' }
      end
    end
  end

  # DELETE /staff/1
  # DELETE /staff/1.json
  def destroy
    @staff = Staff.find(params[:id])
    @staff.destroy

    respond_to do |format|
      format.html { redirect_to @staff.user }
      format.js
    end
  end
end
