class Plugman
  class ConfigLoader

    def initialize(config)
      @config = config || []
    end

    def call(logger)
      @config.each { |f| require_plugin(logger, f) }
    end

    private
    
    def require_plugin(logger, f)
      logger.info "Requiering #{f}"
      require f
    rescue => e
      logger.error(e.class.to_s + ": " + e.message)
    end

  end
end
