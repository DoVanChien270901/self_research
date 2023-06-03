class SearchController < ApplicationController
  def index
    @data = BookIndex.simple_query_string(keyword: param[:kw], page: param[:page]).load
    puts @data.to_h
  end
end
