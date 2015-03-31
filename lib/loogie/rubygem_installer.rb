require 'bundler'

module Loogie
  class RubygemInstaller
    class << self

      def install(spec)
        if dir = find_gem_install_dir(spec)
          dir
        else
          install_gem(spec)
        end
      end

      private

      def install_gem(spec)
        result = Gem.install(spec['name'], spec['version'])
        result.first.full_gem_path
      end

      def find_gem_install_dir(spec)
        found = dirnames_for(spec).find do |dirname|
          Bundler.bundle_path.join('gems').join(dirname).exist?
        end

        if found
          Bundler.bundle_path.join('gems').join(found).to_s
        end
      end

      def dirnames_for(spec)
        base = "#{spec['name']}-#{spec['version']}"
        [base] + Gem.platforms.map do |platform|
          "#{base}-#{platform.to_s}"
        end
      end

    end
  end
end
