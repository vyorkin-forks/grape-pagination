require 'active_support/core_ext/object'
require 'grape'

require 'grape/pagination/version'
require 'grape/pagination/configuration'
require 'grape/pagination/extensions'
require 'grape/pagination/helpers'
require 'grape/validations/validations'

module Grape
  module Pagination
    autoload :Paginator,     'grape/pagination/paginator'
    autoload :LinkHeader,    'grape/pagination/link_header'
    
    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield configuration
    end

    Grape::API.send :extend, Grape::Pagination::Extensions
    Grape::Endpoint.send :include, Grape::Pagination::Helpers
  end
end
