class SearchController < ApplicationController
  skip_authorization_check

  def index
    @restricted = 0
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
