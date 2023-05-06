require 'faker'
module Import
  module Masters
    class Base
      SIZE = 25
      def books
        arr_func_title = [proc { Faker::Movie.unique.title },
                          proc { Faker::Book.unique.title },
                          proc { Faker::Game.unique.title },
                          proc { Faker::Fantasy::Tolkien.unique.character },
                          proc { Faker::Creature::Animal.unique.name }]
        puts '==> importing..............'
        arr_books = []

        arr_func_title.each do |title|
          loop do
            book = Book.new(title: title.call,
                            publisher: Faker::Book.publisher,
                            genre: Genre.new(id: randum),
                            price: rand(150...979),
                            author: Author.new(id: randum))
            arr_books << book
          rescue StandardError => e
            puts e
            break
          end
        end
        Book.import arr_books, on_duplicate_key_ignore: true, validate: false
        puts '==> Import done'
      end

      def authors
        puts '  ==> import  master author...'
        arr_authors = []
        for _i in 1..SIZE
          author = Author.new(a_name: Faker::Book.author)
          arr_authors << author
        end
        Author.import arr_authors, on_duplicate_key_ignore: true, validate: false
        puts '  ==> done 1'
      end

      def genres
        puts ' ==> import master genres'
        arr_genres = []
        for _i in 1..SIZE
          author = Genre.new(g_name: Faker::Book.author)
          arr_genres << author
        end
        Genre.import arr_genres, on_duplicate_key_ignore: true, validate: false
        puts '  ==> done 1'
      end

      private

      def randum
        case rand(1..3)
        when 1
          rand(1...2)
        when 2
          rand(2...6)
        else
          rand(6...SIZE)
        end
      end
    end
  end
end
