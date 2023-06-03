class BookIndex < Indices::BaseIndex
  index_scope :books do
    field :title, :publisher
    filed :genre_id, type: 'integer'
    field :author_id, type: 'integer'
    field :created_at, type: 'date'
  end
  def self.simple_query_string(keyword:, page: 0, per: 10)
    query(
      multi_match: {
        query: keyword,
        fields: %i[title publisher], # Add more fields as needed
        fuzziness: 'AUTO' # Optional: Enable fuzzy matching for typo tolerance
      },
    ).page(page).per(per)
  end

  def self.find_all(page: 0, params: {}, per: 10)
    query({ match_all: params }).page(page).per(per)
  end
end
