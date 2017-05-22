# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'swift_poems_project/version'

Gem::Specification.new do |spec|
  spec.name        = 'swift_encode'
  spec.version     = SwiftPoemsProject::VERSION
  spec.summary     = "Swift Poems Project Encoding API"
  spec.description = "A TEI encoding API for the Swift Poems Project"
  spec.authors     = ["James R. Griffin III"]
  spec.email       = 'griffinj@lafayette.edu'
  spec.files       = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  spec.test_files  = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.homepage    = 'https://github.com/LafayetteCollegeLibraries/swift-encode'
  spec.license     = 'GPL-3.0'

  spec.add_dependency 'fastercsv', '~> 1.5'
  spec.add_dependency 'google-api-client', '~> 0.11'
  spec.add_dependency 'mail', '~> 2.6'
  spec.add_dependency 'nokogiri', '~> 1.7'
  spec.add_dependency 'parseconfig', '~> 1.0'
  spec.add_dependency 'thor', '~> 0.19'

  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'rspec-mocks', '~> 3.5'
end
