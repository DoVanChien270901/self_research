class ReferenceBooksAuthor < ActiveRecord::Migration[7.0]
  def change
    add_reference :books, :author, index: true
  end
end
