require 'rubygems/package'

module Loogie
  class Packager

    attr_reader :output_tars

    def initialize(output_streams)
      @output_tars = output_streams.map do |output_stream|
        Gem::Package::TarWriter.new(output_stream)
      end
    end

    def write_directory(path)
      Dir[File.join(path, "**/*")].each do |file|
        mode = File.stat(file).mode
        relative_file = file.sub(/^#{Regexp::escape(File.dirname(path))}\/?/, '')

        output_tars.each do |tar|
          if File.directory?(file)
            tar.mkdir(relative_file, mode)
          else
            tar.add_file(relative_file, mode) do |tf|
              File.open(file, "rb") { |f| tf.write(f.read) }
            end
          end
        end
      end

    end

    def close
      output_tars.each(&:close)
    end
  end
end
