require 'sinatra/base'
require 'sinatra/streaming'
require 'json'

module Loogie
  class Server < Sinatra::Application

    helpers Sinatra::Streaming

    TAR_PATH = '/data/tars'.tap do |path|
      FileUtils.mkdir_p(path)
    end

    post '/gemtar' do
      params = JSON.parse(request.body.read)
      paths = Installer.install(params['gems'])

      hash = BundleHash.from_gems(params['gems'])
      filename = File.join(TAR_PATH, "#{hash}.tar")

      if File.exist?(filename)
        send_file(filename, filename: filename, type: 'Application/octet-stream')
      else
        headers('Content-Type' => 'application/octet-stream')
        streams = [File.open(filename, 'w')]
        packager = Packager.new(streams)

        paths.each do |path|
          puts "Packaging #{path}"
          packager.write_directory(path)
        end

        send_file(filename, filename: filename, type: 'Application/octet-stream')
      end
    end

  end
end
