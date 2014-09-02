require 'spec_helper'

describe Grape::Pagination::Paginator do
  let(:request      ) { double(Rack::Request, url: 'https://localhost:5000/api/v1/tweets?page=1&per_page=30') }
  let(:endpoint     ) { double(Grape::Endpoint, request: request, header: nil, params: Hashie::Mash.new(page: 1, per_page: 30)) }
  let(:collection   ) { MockRelation.new((0..100).to_a) }
  subject(:paginator) { described_class.new endpoint, collection }

  describe '.paginate' do
    describe 'sets the headers' do
      it 'without previous and first link' do
        endpoint = double(Grape::Endpoint, request: request, header: nil, params: Hashie::Mash.new(page: 1, per_page: 30))
        paginator = described_class.new(endpoint, collection)

        expect(endpoint).to receive(:header).with('Link',
          '<https://localhost:5000/api/v1/tweets?page=2&per_page=30>; rel="next", ' + \
          '<https://localhost:5000/api/v1/tweets?page=4&per_page=30>; rel="last"'
          )
        paginator.paginate
      end

      it 'with all links' do
        endpoint = double(Grape::Endpoint, request: request, header: nil, params: Hashie::Mash.new(page: 2, per_page: 30))
        paginator = described_class.new(endpoint, collection)

        expect(endpoint).to receive(:header).with('Link',
          '<https://localhost:5000/api/v1/tweets?page=1&per_page=30>; rel="first", ' + \
          '<https://localhost:5000/api/v1/tweets?page=1&per_page=30>; rel="prev", ' + \
          '<https://localhost:5000/api/v1/tweets?page=3&per_page=30>; rel="next", ' + \
          '<https://localhost:5000/api/v1/tweets?page=4&per_page=30>; rel="last"'
          )
        paginator.paginate
      end

      it 'without next and last link' do
        endpoint = double(Grape::Endpoint, request: request, header: nil, params: Hashie::Mash.new(page: 4, per_page: 30))
        paginator = described_class.new(endpoint, collection)

        expect(endpoint).to receive(:header).with('Link',
          '<https://localhost:5000/api/v1/tweets?page=1&per_page=30>; rel="first", ' + \
          '<https://localhost:5000/api/v1/tweets?page=3&per_page=30>; rel="prev"'
          )
        paginator.paginate
      end
    end

    it 'paginates the collection' do
      expect(collection).to receive(:paginate).with(page: 1, per_page: 30).and_call_original
      paginator.paginate
    end

    it 'paginates with default block' do
      Grape::Pagination.configuration.paginate_with do |col, params|
        col.paginate(params)
      end
      expect(collection).to receive(:paginate).with(page: 1, per_page: 30).and_call_original
      paginator.paginate
      Grape::Pagination.configuration.pagination_proc = nil
    end

    it 'paginates with custom block' do
      expect(collection).to receive(:page).with(1).and_call_original
      expect(collection).to receive(:per).with(30).and_call_original
      paginator.paginate do |col, params|
        col.page(params[:page]).per(params[:per_page])
      end
    end
  end
end
