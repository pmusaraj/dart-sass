# Dart Sass Wrapper

This gem uses the Dart Sass executables to compile stylesheets.

## Example usage

```ruby
require 'dart-sass'

opts = {
  sourcefile: "vendor/bootstrap/scss/bootstrap.scss",
}

result, sourcemap = DartSass.new(opts).compile
```
