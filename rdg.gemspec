# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rdg/version'

Gem::Specification.new do |spec|
  spec.name          = "rdg"
  spec.version       = RDG::VERSION
  spec.authors       = ["Louis Rose"]
  spec.email         = ["louis.rose@york.ac.uk"]
  spec.description   = %q{Provides dependency analysis of Ruby programs, including control and data flow analysis.}
  spec.summary       = %q{Dependency analysis for Ruby programs}
  spec.homepage      = "https://github.com/mutiny/rdg"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "parser", "~> 2.2.0.2"
  spec.add_runtime_dependency "rgl", "~> 0.5.0"
  
  spec.add_development_dependency "bundler", "~> 1.8.0"
  spec.add_development_dependency "rake", "~> 10.4.2"
  spec.add_development_dependency "rspec", "~> 3.2.0"
  spec.add_development_dependency "coveralls", "~> 0.7.9"
  spec.add_development_dependency "rubocop", "~> 0.29.0"
end
