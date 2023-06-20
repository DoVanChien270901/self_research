module Import
  class CrawlBookswagon
    PER = 20
    URL = 'https://www.bookswagon.com/ajax.aspx/GetCategorySearchResult'.freeze
    def initialize
      @agent = Mechanize.new
      @agent.user_agent_alias =
        [
          'Mac Safari',
          'Linux Mozilla',
          'Mac Firefox',
          'Windows Mozilla',
          'Windows IE 6',
        ][
          rand(0..4)
        ]
    end

    def call
      page = (Book.count / PER) + 1
      puts "crawling............page-#{page}"
      data = {
        searchTerm: '*:*',
        ID_Search: 0,
        next_item_index: page,
        filter: 'category',
        ID_ProductType: 1,
        IsAlterQuery: true,
        FilterQuery: ''
      }
      response =
        @agent.post(URL, data.to_json, { 'Content-Type' => 'application/json' })
      json_data = convert_json_to_html(response.body)
      author_list = scraping_author_on_page(json_data)
      Author.import author_list.compact,
                    on_duplicate_key_ignore: true,
                    validate: false
      book_list = scraping_book_on_page(json_data)
      Book.import book_list, on_duplicate_key_ignore: true, validate: false
      puts 'done.............................'
    end

    def scraping_author_on_page(data_list)
      data_list
        .search('.author-publisher')
        .map do |item|
          Author.new(a_name: item.at('a').text.strip) if item.text.include?('By:')
        end
    rescue StandardError => e
      puts e
    end

    def scraping_book_on_page(page_list)
      hash_authors = Author.select(:id, :a_name).index_by(&:a_name)
      data_list = page_list.search('.list-view-books')
      data_list.map do |book|
        add_book(book, hash_authors)
      rescue StandardError => e
        puts e
      end
    end

    def convert_json_to_html(data_json)
      hash_data = JSON.parse(data_json)
      Nokogiri.HTML(hash_data['d'])
    end

    def add_book(book, hash_authors)
      attr_price =
        book.search('.price-attrib .attributes table .attributes-title')
      Book.new(
        title: book.at_css('.product-summary .title a').text,
        binding: attr_price[0].nil? ? '' : attr_price[0].text,
        price: book.at_css('.price-attrib .price .sell').text.delete('₹'),
        release_date: attr_price[1].nil? ? '' : attr_price[1].text,
        language: attr_price[2].nil? ? '' : attr_price[2].text,
        image_src: book.at_css('.cover a img')['src'],
        publisher:
          book
            .search('.author-publisher')
            .map do |item|
              item.at('a').text.strip if item.text.include?('Publisher:')
            end
            .compact[
            0
          ],
        author_id:
          (
            if book.at_css('.author-publisher a').nil?
              1
            else
              hash_authors[book.at_css('.author-publisher a').text.strip].try(
                :id,
              )
            end
          ),
      )
    end
  end
end
