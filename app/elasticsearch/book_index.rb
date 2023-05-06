class BookIndex < Indices::BaseIndex
  index_scope :books do
    field :title, :publisher
    filed :genre_id, type: 'integer'
    field :author_id, type: 'integer'
    field :created_at, type: 'date'
  end
end
