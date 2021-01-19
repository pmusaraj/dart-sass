require_relative 'lib/dart-sass'

Gem::Specification.new do |s|
  s.name        = 'dart-sass'
  s.version     = DartSass::VERSION
  s.date        = '2020-12-28'
  s.summary     = 'Dart Sass Wrapper'
  s.description = 'Stylesheet compiler using Dart Sass.'
  s.authors     = ["Penar Musaraj"]
  s.email       = 'pmusaraj@gmail.com'
  s.homepage    = 'https://rubygems.org/gems/dart-sass'
  s.license     = 'MIT'
  s.files       = Dir.glob("lib/*") + Dir.glob("ext/**/*") + Dir.glob("packages/**/*") + ["Rakefile", "README.md"]
  s.extensions  = ["ext/extconf.rb"]
end
