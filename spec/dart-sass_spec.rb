# frozen_string_literal: true

RSpec.describe DartSass do
  let!(:dir) { File.expand_path File.dirname(__FILE__) }

  describe '.command' do
    it 'builds a command from source and passes options' do

      opts = {
        sourcefile: "fake.scss",
        "load-path": [
          "common/example1",
          "common/example2"
        ]
      }

      command = described_class.new(opts).send(:command)

      expect(command).to include('fake.scss')
      expect(command).to include('--style compressed')
    end
  end

  describe '.compile' do
    it 'fails for missing source file' do
      opts = {
        sourcefile: "missing.scss",
      }
      expect { described_class.new(opts).compile } .to raise_error(DartSass::Error).with_message("Error reading missing.scss: Cannot open file.\n")
    end

    it 'works on a sample file' do
      opts = {
        sourcefile: "#{dir}/fixtures/sample.scss",
      }

      css, sourcemaps = described_class.new(opts).compile
      expect(css).to include("background-color:green")
    end

    it 'raises syntax error when necessary' do
      opts = {
        sourcefile: "#{dir}/fixtures/scss-error.scss",
      }
      expect { described_class.new(opts).compile } .to raise_error(DartSass::Error).with_message(/Undefined variable/)
    end

    it 'raises error if no source file and no contents' do
      expect { described_class.new.compile } .to raise_error(DartSass::Error).with_message("No sourcefile or content option was provided, you need to specify one of the two.")
    end

    it 'raises syntax error on missing import' do
      opts = {
        sourcefile: "#{dir}/fixtures/missing-import.scss",
      }
      expect { described_class.new(opts).compile } .to raise_error(DartSass::Error).with_message(/Can\'t find stylesheet to import./)
    end

    it 'can include sourcemaps' do
      opts = {
        sourcefile: "#{dir}/fixtures/sample.scss",
        "embed-source-map": true,
      }
      result = described_class.new(opts).compile

      expect(result).to include("background-color:green")
      expect(result).to include("sourceMappingURL")
    end

    it 'works with imports' do
      opts = {
        sourcefile: "#{dir}/fixtures/base.scss",
        "strip-sourcemap-path": [dir]
      }
      css, sourcemap = described_class.new(opts).compile

      expect(css).to include("color:\"red\"")
      expect(css).to include("sourceMappingURL")

      map = JSON.parse(sourcemap)
      expect(map["sources"]).to include("fixtures/includes/additional.scss", "fixtures/includes/variables.scss", "fixtures/base.scss")
    end

  end

  describe '.compile with stdin' do
    let(:scss) { '$color: "#EE4433";body {border: 2px solid $color;}' }

    it 'works' do
      opts = {content: scss}

      result, sourcemap = described_class.new(opts).compile
      expect(result).to include("body{border:2px solid \"#EE4433\"}")
    end

    it 'raises syntax error when necessary' do
      opts2 = {content: <<~SCSS}
        body {
          border: 2px solid $color;
        }
      SCSS
      expect { described_class.new(opts2).compile } .to raise_error(DartSass::Error).with_message(/Undefined variable/)
    end

    it 'can embed source maps when passing content' do
      opts = {
        content: scss,
        "embed-source-map": true,
      }
      result = described_class.new(opts).compile

      expect(result).to include("body{border:2px solid \"#EE4433\"}")
      expect(result).to include("sourceMappingURL")
    end

    it 'works with imports' do
      scss = File.read "#{dir}/fixtures/base.scss"
      opts = {
        content: scss,
        "load-path": [ "#{dir}/fixtures" ],
        "strip-sourcemap-path": [ "#{dir}/fixtures" ]
      }
      css, sourcemap = described_class.new(opts).compile

      expect(css).to include("color:\"red\"")
      expect(css).to include("sourceMappingURL")
      map  = JSON.parse(sourcemap)
      expect(map["sources"]).to include("includes/additional.scss", "includes/variables.scss")
    end

  end

end
