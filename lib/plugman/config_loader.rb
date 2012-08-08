require 'plugman/loader'

class Plugman
  class ConfigLoader < Loader

    def initialize(logger, config)
      super(logger)
      @config = config
    end

    def load_plugins
      @config.each { |f| require_plugin(f) }
    end

  end
end
