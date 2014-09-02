require 'spec_helper'
require 'rack/test'

class API < Grape::API
  paginate
  get do
    present paginate(MockRelation.new((0..100).to_a))
  end
end

# Just need an array like object that responds to `paginate`.
class MockRelation < Array
  def paginate(options)
    per_page    = options[:per_page]
    offset      = per_page * (options[:page] - 1)
    total_pages = (count / per_page.to_f).ceil
    PaginatedRelation.new(slice(offset, per_page),
                          options[:page], total_pages)
  end

  def page(val)
    @page = val
    self
  end

  def per(val)
    paginate(page: @page || 1, per_page: val)
  end
end

class PaginatedRelation < Array
  attr_accessor :current_page, :total_pages

  def initialize(array, current_page, total_pages)
    super(array)
    @current_page = current_page
    @total_pages  = total_pages
  end

  def first_page?
    @current_page == 1
  end

  def next_page
    @current_page + 1 unless last_page?
  end

  def prev_page
    @current_page - 1 unless first_page?
  end

  def last_page?
    @current_page == @total_pages
  end
end

describe Grape::Pagination do
  include Rack::Test::Methods

  def app
    API
  end

  it 'returns a paginated array' do
    get '/'
    expect(last_response.body).to eq (0..29).to_a.to_s
  end

  it 'allows the page to be provided' do
    get '/?page=2'
    expect(last_response.body).to eq (30..59).to_a.to_s
  end

  it 'allows the number of results per page to be provided' do
    get '/?per_page=60'
    expect(last_response.body).to eq (0..59).to_a.to_s
  end

  it 'returns an error if the page param is below 0' do
    get '/?page=0'
    expect(last_response.status).to eq 400
    expect(last_response.body).to eq 'The page param must have a value of 1 or greater.'
  end
end
