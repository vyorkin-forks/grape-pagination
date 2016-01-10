[![Build Status](https://travis-ci.org/vyorkin-forks/grape-pagination.svg)](https://travis-ci.org/vyorkin-forks/grape-pagination)

# Grape Pagination

Provides helpers for paginating collections in [Grape](https://github.com/intridea/grape)
endpoints. It works with with [will\_paginate](https://github.com/mislav/will_paginate) and [Kaminari](https://github.com/amatsuda/kaminari), or something that responds to the same paginate interface.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'grape-pagination'
```

## Usage

Tag your endpoint as supporting pagination params, then use the `paginate`
helper.

```ruby
class API < Grape::API
  desc 'Gets everything!'
  paginate
  get do
    paginate collection
  end
end
```

Which would result in a paginated collection and the following headers set:

```
Link: <http://localhost:3001/api/contacts?page=1&per_page=30>; rel="first", <http://localhost:3001/api/contacts?page=1&per_page=30>; rel="prev", <http://localhost:3001/api/contacts?page=3&per_page=30>; rel="next", <http://localhost:3001/api/contacts?page=105&per_page=30>; rel="last"
```
## Configuration

You can disable links by overriding values using `Grape::Pagination.configure` method.

```ruby
Grape::Pagination.configure do |config|                    
  config.included_links = [:next, :prev] # show only next and previous links
end   

```

### Custom pagination

By default will\_paginate and kaminari are supported. However it is possible to use custom pagination using `paginate\_with`.

```ruby
Grape::Pagination.configure do |config|                      
  config.paginate_with do |collection, params|             
    collection.page(params[:page]).per(params[:per_page]).padding(3)  
  end
end   

```

For more info on how to implement custom pagination you can take a look at:
* https://github.com/amatsuda/kaminari/blob/90a1cd0084807ee160ecf48f8a630458a7f1cfc7/lib/kaminari/models/page_scope_methods.rb
* https://github.com/nviennot/kaminari-nobrainer/blob/master/lib/kaminari/models/nobrainer_extension.rb
* https://github.com/nviennot/kaminari-nobrainer/blob/master/lib/kaminari/models/nobrainer_criteria_methods.rb

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
