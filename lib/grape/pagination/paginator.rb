module Grape::Pagination
  class Paginator
    extend Forwardable

    TOTAL_HEADER = 'X-Total'.freeze
    LINK_HEADER  = 'Link'.freeze

    attr_reader :endpoint
    attr_reader :collection
    attr_reader :options

    def self.paginate(*args, &block)
      new(*args).paginate(&block)
    end

    def initialize(endpoint, collection, options = {})
      @endpoint   = endpoint
      @collection = collection
      @options    = options
    end

    def paginate(&block)
      header LINK_HEADER, LinkHeader.new(request.url, page_params).to_rfc5988
      paginate_collection(collection, page_params, &block)
    end

  private

    def_delegators :endpoint, :header, :params, :request

    def paginate_collection(collection, params, &block)
      if block_given?
        block.call(collection, params)
      elsif configuration.pagination_block
        configuration.pagination_block.call(collection, params)
      else
        collection.paginate(params)
      end
    end

    def page_params
      @page_params ||= params.slice(:page, :per_page).to_h.symbolize_keys
    end

    def configuration
      Grape::Pagination.configuration
    end

  end
end
