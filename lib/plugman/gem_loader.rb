class Plugman
  class GemLoader
    attr_accessor :finder
    attr_reader :policy, :logger

    def initialize(finder, logger=Logger.new)
      @finder = finder
      @logger = logger
    end

    def load_plugins
      finder.plugin_files.each { |f| require_plugin(f) }
    end

    def require_plugin(f)
      logger.debug "Requiering #{f}"
      require f
    rescue => e
      logger.error(e.class.to_s + ": " + e.message)
    end

  end
end
