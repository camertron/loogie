module Loogie
  class Installer
    class << self

      def install(specs)
        specs.map do |spec|
          case spec['type']
            when 'rubygems'
              RubygemInstaller.install(spec)
            when 'git'
              GitInstaller.install(spec)
          end
        end
      end

    end
  end
end
