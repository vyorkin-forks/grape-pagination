module Grape::Pagination
  class Paginator
    extend Forwardable

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
      paginated = paginate_collection(collection, page_params, &block)
      link = LinkHeader.new(request.url, paginated, page_params)
      header LINK_HEADER, link.to_rfc5988
      paginated
    end

  private

    def_delegators :endpoint, :header, :params, :request

    def paginate_collection(collection, params, &block)
      if block_given?
        block.call(collection, params)
      elsif configuration.pagination_proc
        configuration.pagination_proc.call(collection, params)
      else
        fail StandardError, 'Failed to paginate'
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
