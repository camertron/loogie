require 'digest/sha1'

module Loogie
  class BundleHash
    class << self

      def from_gems(gems)
        str = gems.map { |gem_data| gem_str(gem_data) }.sort.join('|')
        Digest::SHA1.hexdigest(str)
      end

      protected

      def gem_str(gem_data)
        "#{gem_data['name']}/#{gem_data['version']}"
      end

    end
  end
end
