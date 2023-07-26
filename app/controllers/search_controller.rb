require 'will_paginate/array'

class SearchController < ApplicationController
  def index
    @resource = params[:resource]
    @query = params[:query]
    @results = SearchService.new(@resource, @query).call.paginate(page: params[:page], per_page: 5)
  end
end
