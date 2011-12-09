class Plugman
  class SimpleFinder

    def initialize(dir)
      @dir = File.absolute_path(dir)
    end

    def plugin_files
      Dir.glob(@dir + '/*')
    end

  end
end
