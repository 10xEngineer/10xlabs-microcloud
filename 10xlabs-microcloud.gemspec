# -*- encoding: utf-8 -*-
require File.expand_path('../lib/10xlabs/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Radim Marek"]
  gem.email         = ["radim@10xengineer.me"]
  gem.description   = %q{10xLabs Microcloud client}
  gem.summary       = %q{}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "microcloud"
  gem.require_paths = ["lib"]
  gem.version       = TenxLabs::VERSION

  gem.add_dependency "httparty", "~> 0.8.3"
  gem.add_dependency "yajl-ruby", "~> 1.1.0"
  gem.add_dependency "activesupport", "~> 3.2.6"
  gem.add_dependency "commander", "~> 4.1.2"

  gem.add_development_dependency "rspec", "~> 2"
end
