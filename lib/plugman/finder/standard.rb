
require 'rubygems'

class Plugman
  module Finder
    class Standard

      def initialize(glob)
        @glob = glob
      end

      def plugin_files
        # FIX assuming here that array is sorted correctly. Assumption correct?
        seen = {}
        Gem.find_files(@plugin_glob, true).each do |p|
          name = File.basename(p)
          require p unless seen[name]
          seen[name] = true
        end

      end

    end
  end
end
