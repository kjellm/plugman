require 'plugman/loader'

class Plugman
  class DirLoader < Loader

    def initialize(logger, dir)
      super(logger)
      @dir = File.absolute_path(dir)
    end

    def load_plugins
      plugin_files.each { |f| require_plugin(f) }
    end

    private

    def plugin_files
      Dir.glob(@dir + '/*')
    end

  end
end
