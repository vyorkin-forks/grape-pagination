module Grape::Pagination
  class Configuration
    DEFAULT_LINKS = [:first, :prev, :next, :last].freeze

    attr_accessor :included_links
    attr_accessor :pagination_proc
    attr_accessor :first_page_proc, :prev_page_proc,
                  :next_page_proc, :last_page_proc

    def initialize
      @included_links  = DEFAULT_LINKS.dup
      @first_page_proc = lambda { |col| 1 unless col.first_page? }
      @prev_page_proc  = lambda { |col| col.prev_page }
      @next_page_proc  = lambda { |col| col.next_page }
      @last_page_proc  = lambda { |col| col.total_pages unless col.last_page? }
    end

    def paginate_with(&block)
      @pagination_proc = block
    end
  end
end
