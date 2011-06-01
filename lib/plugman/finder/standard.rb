require 'rubygems'

class Plugman
  module Finder
    class Standard

      def initialize(name)
        @glob = "#{name}/plugin/*"
      end

      def plugin_files
        # FIX assuming here that array is sorted correctly. Assumption correct?
        seen = {}
        files = []
        Gem.find_files(@glob, true).each do |p|
          name = File.basename(p)
          files << p unless seen[name]
          seen[name] = true
        end
        files
      end

    end
  end
end
