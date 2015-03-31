require 'bundler'

module Loogie
  class GitInstaller
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
        git_source = Bundler::Source::Git.new(spec).tap do |source|
          source.instance_variable_set(:@allow_remote, true)
          source.instance_variable_set(:@allow_cached, true)
        end

        git_proxy = git_source.send(:git_proxy)
        git_proxy.checkout

        short_ref = git_source.send(:shortref_for_path, git_proxy.revision)
        install_path = Bundler.install_path.join(
          "#{spec['name']}-#{short_ref}"
        )

        git_proxy.copy_to(install_path, [])
        install_path.to_s
      end

      def find_gem_install_dir(spec)
        gem_base = "#{spec['name']}-#{spec['ref']}"
        Dir.glob(Bundler.install_path.join('**').to_s).find do |install_path|
          install_base = File.basename(install_path)
          length = [gem_base.length, install_base.length].min
          install_base[0...length] == gem_base[0...length]
        end
      end

    end
  end
end
