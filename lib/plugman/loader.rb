class Plugman
  class Loader

    def initialize(logger)
      @logger = logger
    end
    
    def require_plugin(f)
      @logger.info "Requiering #{f}"
      require f
    rescue => e
      @logger.error(e.class.to_s + ": " + e.message)
    end

  end
end
