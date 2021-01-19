# frozen_string_literal: true

require 'open3'
require 'tempfile'
require 'json'

class DartSass
  VERSION = "0.1.5"
  DART_VERSION = "1.32.4"

  class Error < StandardError; end

  DEFAULT_OPTIONS = {
    :style => 'compressed',
    :"stop-on-error" => true
  }

  def initialize(options={})
    gem_root = File.expand_path('..', __dir__)
    executable_dir = File.join(gem_root, 'ext', "dart-sass")

    @compiler = "#{executable_dir}/sass"
    @content = options.delete(:content) || nil
    @source = options.delete(:sourcefile) || nil
    @strip_paths = options.delete(:"strip-sourcemap-path") || nil

    @options  = DEFAULT_OPTIONS.merge(options)
    @tempfile = Tempfile.new('dart-sass-temp-file')
  end

  def compile
    _, stderr, status = Open3.capture3(*command, stdin_data: @content)

    if status.success?
      css = File.read @tempfile.path

      if no_sourcemap_files
        @tempfile.close
        @tempfile.unlink
        return css
      end

      sourcemap = File.read "#{@tempfile.path}.map"
      sourcemap = fix_sourcemaps(sourcemap) if @strip_paths

      @tempfile.close
      @tempfile.unlink

      return [ css, sourcemap ]
    end

    @tempfile.close
    @tempfile.unlink
    raise Error.new stderr
  end

  private

  def no_sourcemap_files
    @options[:"no-source-map"] || @options[:"embed-source-map"]
  end

  def serialize_options(options)
    options.map do |k, v|
      if v == true
        "--#{k}"
      elsif (v.is_a?(Array))
        v.map {|v2| ["--#{k}", v2.to_s]}
      else
        ["--#{k}", v.to_s]
      end
    end.flatten
  end

  def command
    src = @source || "--stdin"

    if @source || @content
      "#{@compiler} #{src} #{@tempfile.path} #{serialize_options(@options).flatten.join(' ')}"
    else
      raise Error.new "No sourcefile or content option was provided, you need to specify one of the two."
    end
  end

  def fix_sourcemaps(file)
    return file if @options[:"source-map-urls"] == "absolute"
    return file unless @strip_paths

    sources = []
    data = JSON.parse(file)

    @strip_paths.each do |path|
      data["sources"].each do |src|
        src = src.gsub(path, "")
        src = src.gsub("../", "")
        sources << src
      end
    end

    data["sources"] = sources
    JSON.generate(data)
  end
end
