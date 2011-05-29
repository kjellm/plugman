class Plugman
  module Finder
    class Simple

      def initialize(dir)
        @dir = File.absolute_path(dir)
      end

      def plugin_files; Dir.glob(@dir + '/*'); end

    end
  end
end
