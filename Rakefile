require 'rake'
require_relative 'lib/dart-sass'

BASE_URL = "https://github.com/sass/dart-sass/releases/download"

desc "Download executables for current version"
task :pull_dart do
  platforms = %w[darwin linux]
  cpu = "x64"
  # TODO: Add Windows support, ia32

  platforms.each do |os|
    platform = os == "darwin" ? "macos" : os
    url = "#{BASE_URL}/#{DartSass::DART_VERSION}/dart-sass-#{DartSass::DART_VERSION}-#{platform}-#{cpu}.tar.gz"
    `cd packages\/#{platform} && wget -O dartsass-#{DartSass::DART_VERSION}.tar.gz #{url}`
  end
end
