module Grape::Pagination
  class Configuration
    attr_accessor :pagination_block

    def paginate_with(&block)
      @pagination_block = block
    end
  end
end
