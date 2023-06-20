class BookIndex < Indices::BaseIndex
  index_scope :books do
    field :title, type: 'string'
    filed :binding, type: 'string'
    field :author_id, type: 'integer'
    field :publisher, type: 'date'
    field :language, type: 'date'
    field :price, type: 'float'
    field :release_date, type: 'string'
  end
  def self.simple_query_string(keyword: '*', page: 0, per: 12)
    keyword = '*' if keyword.blank?
    Book.search(keyword).page(page).per(per).records.includes(:author)
  end

  def self.find_all(page: 0, params: {}, per: 12)
    query({ match_all: params }).page(page).per(per)
  end
end
