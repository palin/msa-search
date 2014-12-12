require 'open-uri'

class Search
  attr_reader :query

  def initialize(query)
    @query = query
  end

  def results
    english_result, welsh_result = search

    OpenStruct.new(english: english_result, welsh: welsh_result)
  end

  private
    def mas_domain
      'https://www.moneyadviceservice.org.uk'
    end

    def new_result_object(url, title)
      OpenStruct.new(url: url, title: title)
    end

    def search
      english_result = english_search rescue nil

      welsh_result = if english_result.present?
                         welsh_search(english_result) rescue nil
                      end

      [english_result, welsh_result]
    end

    def english_search
      # call MAS website search with given query and get html
      doc = Nokogiri::HTML(open("#{mas_domain}/en/search?query=#{query}"))

      # get first result item
      search_item = doc.css('ol.search-results .search-results__item').first

      # get english article url and title
      result_url = search_item.css('h2 a').first['href']
      result_title = search_item.css('h2 a').first.content

      new_result_object(result_url, result_title)
    end

    def welsh_search(english_result)
      # call MAS website english article url
      english_doc = Nokogiri::HTML(open(english_result.url))

      # get Cymraeg element which stores welsh article link
      search_item = english_doc.css('.authentication__item.l-language-link').first

      # welsh article link
      language_link = search_item.css('a').first['href']

      # welsh article link can have full url (with domain) or path (without domain)
      welsh_doc, result_url = begin
                                [Nokogiri::HTML(open(language_link)), language_link]
                              rescue
                                # try adding domain to the path
                                [Nokogiri::HTML(open("#{mas_domain}/#{language_link}")), "#{mas_domain}/#{language_link}"]
                              end

      result_title = welsh_doc.css('main.l-main__cell-single h1').first.content

      new_result_object(result_url, result_title)
    end
end