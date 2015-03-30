require 'sinatra/base'
require 'fileutils'
require 'pry-nav'

module Loogie
  class Server < Sinatra::Application

    TAR_PATH = '/data/tars'.tap do |path|
      FileUtils.mkdir_p(path)
    end

    post '/gemtar' do
      gemfile = params.fetch('gemfile')
      lockfile = params.fetch('lockfile')

      Dir.mktmpdir do |dir|
        gemfile_path = File.join(dir, 'Gemfile')
        lockfile_path = File.join(dir, 'Gemfile.lock')

        File.open(gemfile_path, 'w') { |f| f.write(gemfile) }
        File.open(lockfile_path, 'w') { |f| f.write(lockfile) }

        binding.pry
        definition = Bundler::Definition.build(
          gemfile_path, lockfile_path, false
        )

        specs = definition.specs
        Installer.install(definition)

        hash = BundleHash.from_definition(specs)
        filename = File.join(TAR_PATH, "#{hash}.tar")

        if File.exist?(filename)
          send_file(filename, filename: filename, type: 'Application/octet-stream')
        else
          headers('Content-Type' => 'application/octet-stream')

          stream do |out|
            streams = [File.open(filename), out]
            packager = Packager.new(streams)

            specs.each do |spec|
              packager.write_directory(spec.full_gem_path)
            end
          end
        end
      end
    end

  end
end
