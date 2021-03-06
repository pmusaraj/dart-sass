# Compile SCSS using Dart Sass

This gem uses the Dart Sass executable to compile your stylesheets.

## Installation

Add it to your application's Gemfile:

```ruby
gem 'dart-sass'
```

And install using Bundler:

```
bundle install
```

Or install it manually via:

```
gem install dart-sass
```

## Example usage

```ruby
require 'dart-sass'

opts = {
  sourcefile: "vendor/bootstrap/scss/bootstrap.scss",
}

css, sourcemap = DartSass::Engine.new(opts).compile
```

Currently only one-to-one mode is supported.

## Options

This wrapper supports the input and output [dart-sass](https://sass-lang.com/documentation/cli/dart-sass) CLI options plus:

#### sourcefile

Load a SCSS file from the filesystem (see example above).

#### content

Load inline SCSS. Example:

```ruby
opts = {
  content: '$color: "#EE4433"; body {border: 2px solid $color;}'
}
css, sourcemap = DartSass::Engine.new(opts).compile
```

Note: one of `sourcefile` or `content` must be provided.

#### custom-cli-path

Use a different Dart Sass binary than the one included with the gem:

```ruby
custom_cli_path = "/usr/local/Cellar/sass/1.30.0/bin/sass"

opts = {
  sourcefile: "example.scss",
  "custom-cli-path": custom_cli_path
}
result = DartSass::Engine.new(opts).compile
```

#### output

Switches the output to a file in the filesystem (by default, the compiled CSS and sourcemap are returned, like in the examples above).

```ruby
opts = {
  sourcefile: "example.scss",
  output: "example.css"
}
result = DartSass::Engine.new(opts).compile

# outputs example.css and example.css.map in the current directory
```

#### strip-sourcemap-paths

Strips file paths in sourcemaps from a provided array.

```ruby
opts = {
  content: scss,
  "load-path": [ "#{dir}/fixtures" ],
  "strip-sourcemap-path": [ "#{dir}/fixtures" ]
}

css, sourcemap = DartSass::Engine.new(opts).compile
```
