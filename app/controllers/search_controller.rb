class SearchController < ApplicationController
  def index
    @results = GoogleCustomSearchApi.search("nasi goreng")
  end
end
