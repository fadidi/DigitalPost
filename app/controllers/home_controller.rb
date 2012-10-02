class HomeController < ApplicationController
  skip_authorization_check

  def index
    render :layout => 'one_column-fixed'
  end
end
