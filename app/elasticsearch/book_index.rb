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
end
