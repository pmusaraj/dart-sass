require 'mkmf'
require_relative '../lib/dart-sass'

platform = Gem::Platform.local.os == "darwin" ? "macos" : Gem::Platform.local.os
`tar -xzvf ../packages\/#{platform}/dartsass-#{DartSass::DART_VERSION}.tar.gz`
create_makefile('dart-sass/sass')
