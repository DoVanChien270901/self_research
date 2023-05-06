class Book < ApplicationRecord
  update_index('users') { self }
  belongs_to :author
  belongs_to :genre
end
