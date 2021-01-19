require 'mkmf'
require_relative '../lib/dart-sass'

BASE_URL = "https://github.com/sass/dart-sass/releases/download"
platform = Gem::Platform.local.os == "darwin" ? "macos" : Gem::Platform.local.os
`tar -xzvf ../packages\/#{platform}/dartsass-#{DartSass::DART_VERSION}.tar.gz`
create_makefile('dart-sass/sass')
