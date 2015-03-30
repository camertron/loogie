require 'bundler'

module Loogie
  class Installer
    class << self

      def install(definition)
        if definition.missing_specs.size > 0
          installer = Bundler::Installer.new(nil, definition)
          installer.run({})
        end
      end

    end
  end
end
