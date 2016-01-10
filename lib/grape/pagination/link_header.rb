require 'addressable/uri'

module Grape::Pagination
  class LinkHeader
    attr_reader :url
    attr_reader :page_params

    def initialize(url, collection, page_params)
      @url = url
      @collection  = collection
      @page_params = page_params
    end

    def first
      page_link = configuration.first_page_proc.call(@collection)
      Link.new(url, 'first', page_params.merge(page: page_link)) if page_link
    end

    def prev
      page_link = configuration.prev_page_proc.call(@collection)
      Link.new(url, 'prev', page_params.merge(page: page_link)) if page_link
    end

    def next
      page_link = configuration.next_page_proc.call(@collection)
      Link.new(url, 'next', page_params.merge(page: page_link)) if page_link
    end

    def last
      page_link = configuration.last_page_proc.call(@collection)
      Link.new(url, 'last', page_params.merge(page: page_link)) if page_link
    end

    def to_rfc5988
      configuration.included_links.map do |type|
        link = __send__(type)
        link.to_s if link
      end.compact.join(', ')
    end

    private

    def configuration
      Grape::Pagination.configuration
    end

    class Link
      attr_reader :url, :rel, :page_params

      def initialize(url, rel, page_params)
        @url, @rel, @page_params = url, rel, page_params
      end

      def to_s
        %(<#{uri.to_s}>; rel="#{rel}")
      end

      private

      def uri
        @uri ||= begin
          uri = Addressable::URI.parse(url)
          uri.query_values = (uri.query_values || {}).merge(page_params.stringify_keys)
          uri
        end
      end
    end
  end
end
