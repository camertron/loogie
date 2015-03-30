require 'digest/sha1'

module Loogie
  class BundleHash
    class << self

      def from_definition(specs)
        digest = Digest::SHA1.new

        sort_specs(specs).each do |spec|
          digest << "#{spec.name}/#{spec.version}"
        end

        digest.hexdigest
      end

      protected

      def sort_specs(specs)
        specs.sort_by(&:name)
      end

    end
  end
end
