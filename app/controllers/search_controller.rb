class SearchController < ApplicationController
  def index
    @authors = Author.all.index_by(&:id)
    @data = BookIndex.simple_query_string(keyword: params[:kw])
    @aggregations =
      Book.search(
        aggs: {
          avg_by_author: {
            terms: {
              field: :author_id
            }
          }
        },
      ).aggregations[:avg_by_author][:buckets]
  end
end
