require 'faker'
module Import
  module Masters
    class Base
      def self.books
        puts '==> importing..............'
        arr_books = []
        for _i in 0..10000 do
          book = Book.new(title: Faker::Book.title,
                          publisher: Faker::Book.publisher,
                          genre: Faker::Book.genre,
                          author: Author.new(id: rand(1...100)))
          arr_books << book
        end
        Book.import arr_books, on_duplicate_key_ignore: true, validate: false
        puts '==> Import done'
      end

      def self.authors
        puts '  ==> import  master author...'
        arr_authors = []
        for _i in 0..100
          author = Author.new(name: Faker::Book.author)
          arr_authors << author
        end
        Author.import arr_authors, on_duplicate_key_ignore: true, validate: false
        puts '  ==> done 1'
      end
    end
  end
end
