module Grape::Pagination
  class Configuration
    DEFAULT_LINKS = [:first, :prev, :next, :last].freeze

    attr_accessor :included_links
    attr_accessor :pagination_proc
    attr_accessor :first_page_proc, :prev_page_proc,
                  :next_page_proc, :last_page_proc

    def initialize
      @included_links  = DEFAULT_LINKS.dup
      @first_page_proc = ->(col) { 1 if col.current_page > 1 }
      @prev_page_proc  = ->(col) { col.try(:previous_page) or col.prev_page }
      @next_page_proc  = ->(col) { col.next_page }
      @last_page_proc  = ->(col) { col.total_pages if col.current_page < col.total_pages }
      @pagination_proc = lambda do |col, params|
        if col.respond_to? :paginate
          col.paginate(params)
        elsif col.respond_to? :page
          col.page(params[:page]).per(params[:per_page])
        end
      end
    end

    def paginate_with(&block)
      @pagination_proc = block
    end
  end
end
