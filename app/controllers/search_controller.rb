class SearchController < ApplicationController
  authorize_resource

  respond_to :html

  def search
    respond_with(@search_results = Search.search_result(params[:query], params[:condition]))
  end
end
