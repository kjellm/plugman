require 'rubygems'

class Plugman
  class GemFinder

    def initialize(name)
      @glob = "#{name}/plugin/*"
    end

    def plugin_files
      # FIXME assuming here that array is sorted correctly. Assumption correct?
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
