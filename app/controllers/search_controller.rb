class SearchController < ApplicationController
  def index
    result_query = BookIndex.query(query_base)
                            .aggregations(author_agg)
                            .limit(16)
    @books_count = result_query.count
    @books = result_query.to_a
    @facet = result_query.aggregations["author_ids"]["buckets"]
    @authors = Author.select(:id, :a_name).index_by(&:id)
    @genres = Genre.select(:id, :g_name).index_by(&:id)
  end

  def by_author
    binding.pry
  end

  private

  def search_params
    params[:kw].present? ? params[:kw] : ''
  end

  def author_agg
    {
      author_ids: {
        terms: { field: 'author_id', size: 1000 },
        aggs: genre_agg
      }
    }
  end

  def genre_agg
    {
      genres: {
        terms: { field: 'genre_id', size: 1000 }
      }
    }
  end

  def query_base
    if params[:kw].present?
      { multi_match: { fields: %w[title publisher], query: params[:kw] } }
    else
      { match_all: {} }
    end
  end
end
