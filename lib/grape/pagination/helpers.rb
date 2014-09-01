module Grape::Pagination
  module Helpers
    def paginate(*args, &block)
      Grape::Pagination::Paginator.paginate(self, *args, &block)
    end
  end
end
