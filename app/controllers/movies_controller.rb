class MoviesController < ApplicationController
  include Refiner::Query
  
  before_action :beautify_search_url, only: [:index]

  def index
    search  = Movie.custom_search(segmented_query)
    # @aggs   = search.response.aggregations.map { |a| AggregationPresenter.new(a) }
    @movies = search.results
  end

private

  def beautify_search_url
    redirect_to search_movies_path(query: "keyword/#{params[:q]}") if params[:q].present?
  end

  def segmented_query
    segment_refiner_query_by("crews", "keyword", "genres")
  end

  helper_method :segmented_query
end
