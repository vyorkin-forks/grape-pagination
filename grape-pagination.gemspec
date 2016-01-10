lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grape/pagination/version'

Gem::Specification.new do |spec|
  spec.name = 'grape-pagination'
  spec.version = Grape::Pagination::VERSION::STRING
  spec.authors = ['Eric J. Holmes']
  spec.email = ['eric@ejholmes.net']
  spec.description = %q{Pagination helpers for Grape}
  spec.summary = %q{Pagination helpers for Grape}
  spec.homepage = 'https://github.com/vyorkin-forks/grape-pagination'

  spec.files = `git ls-files -- lib/*`.split("\n")
  spec.files += %w(README.md LICENSE.txt)
  spec.bindir = 'exe'
  spec.executables = `git ls-files -- exe/*`.split("\n").map { |file| File.basename(file) }


  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_path = 'lib'
  spec.license = 'MIT'

  spec.add_runtime_dependency 'grape', '~> 0.14'
  spec.add_runtime_dependency 'addressable'
  spec.add_runtime_dependency 'activesupport'

  spec.add_development_dependency 'yard', '~> 0.8', '>= 0.8.7'
  spec.add_development_dependency 'yard-rspec', '~> 0.1'
  spec.add_development_dependency 'simplecov', '~> 0.10', '>= 0.10.0'

  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'rack-test', '~> 0.6'
end
