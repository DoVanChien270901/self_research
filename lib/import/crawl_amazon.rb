require 'mechanize'
require 'pry-byebug'
module Import
  class CrawlAmazon
    PER = 18
    URL = 'https://www.amazon.com/s?i=stripbooks&s=relevanceexprank&page='.freeze # page=?
    def initialize
      @agent = Mechanize.new
      @agent.user_agent_alias = 'Mac Safari'
    end

    def call
      puts 'crawling............'
      page_list = @agent.get("#{URL}#{(Book.count / PER) + 1}")
      author_list = scraping_author_on_page(page_list)
      Book.import author_list, on_duplicate_key_ignore: true, validate: false
      book_list = scraping_book_on_page(page_list)
      Book.import book_list, on_duplicate_key_ignore: true, validate: false
      puts 'done...............'
    end

    def scraping_author_on_page(page_list)
      data_list =
        page_list.at('.s-main-slot.s-result-list.s-search-results').search(
          '.s-card-container',
        )
      data_list.map do |book|
        Author.new(a_name: book.at('.a-size-base.a-link-normal.s-underline-text').text)
      rescue StandardError => e
        puts e
      end
    end

    def scraping_book_on_page(page_list)
      hash_authors = Author.select(:id, :a_name).index_by(&:a_name)
      data_list =
        page_list.at('.s-main-slot.s-result-list.s-search-results').search(
          '.s-card-container',
        )
      data_list.map do |book|
        publish_date = book.at('.a-size-base.a-color-secondary.a-text-normal')
        author_name = book.at('.a-size-base.a-link-normal.s-underline-text').text
        Book.new(
          title: book.at('span.a-size-medium').text,
          b_type: book.search('a.a-size-base')[1].text,
          price: book.search('a.a-size-base').at('span.a-offscreen').text,
          publish_date:
            publish_date.nil? ? Date.current : Date.parse(publish_date.text),
          image_src: book.at('img.s-image').get_attribute(:src),
          author_id: hash_authors[author_name].try(:id),
        )
      rescue StandardError => e
        puts e
      end
    end
  end
end
