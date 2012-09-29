class HomeController < ApplicationController
  skip_authorization_check

  def index
    render :layout => 'one_column-fixed'
  end

  def search
    if params[:q].present?
      @results = User.search(params[:q])
    else
      @results = User.all
    end
  end

end
