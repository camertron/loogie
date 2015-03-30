# encoding: utf-8

require File.expand_path('../lib/loogie/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "loogie"
  spec.version       = Loogie::VERSION
  spec.authors       = ["Cameron Dutro"]
  spec.email         = ["camertron@gmail.com"]
  spec.summary       = 'Package up your gem dependencies into a tar archive'
  spec.description   = 'Make ur ci runs fastr'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'pry-nav'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_dependency 'sinatra', '~> 1.4.0'
end
