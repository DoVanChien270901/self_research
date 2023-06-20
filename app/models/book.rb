class Book < ApplicationRecord
  include Elasticsearch::Model

  update_index('users') { self }
  belongs_to :author
  belongs_to :genre
  validates_uniqueness_of :title
  scope :eager, -> { includes(:author) }
end
