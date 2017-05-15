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
  spec.license     = 'GPLv3'
end
