require File.expand_path('lib/gyft/version', File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name        = 'gyft'
  s.version     =  Gyft::VERSION
  s.summary     = "Wrapper for the Gyft API"
  s.description = "Wrapper for the Gyft API"
  s.authors     = ["Cristiano Betta"]
  s.email       = 'cbetta@gmail.com'
  s.files       = Dir.glob('{lib,spec}/**/*') + %w(LICENSE README.md gyft.gemspec)
  s.homepage    = 'https://github.com/cbetta/gyft'
  s.license     = 'MIT'
  s.require_path = 'lib'

  s.add_development_dependency('rake')
  s.add_development_dependency('webmock')
  s.add_development_dependency('minitest')
end
