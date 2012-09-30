class HomeController < ApplicationController
  skip_authorization_check

  def index
    render :layout => 'one_column-fixed'
  end

  def search
    if params[:q].present?
      search = Tire.search ELASTICSEARCH_INDEX do |search|
        search.query do |query|
          query.string params[:q]
        end
      end
      @results = search.results
    else
      @results = User.all
    end
  end

end
