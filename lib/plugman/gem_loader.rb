class Plugman
  class GemLoader
    attr_accessor :finder
    attr_reader :policy, :logger

    def initialize(finder_or_name, logger=Logger.new)
      @finder  = get_finder(finder_or_name)
      @policy  = Plugman::BlackWhitePolicy.new([], []) { |x| true }
      @logger  = logger
    end

    # Looks for plugins, requires them, checks state, initializes, and
    # registers the plugins
    def load_plugins
      policy.apply(finder.plugin_files).each do |f|
        require_plugin(f)
      end

      # All plugins are now registered. Requiering the plugins will
      # magically call Plugman::Plugin::inherited for each
      # plugin. inherited() will in turn call register_plugin()
    end

    def require_plugin(f)
      logger.debug "Requiering #{f}"
      require f
    rescue => e
      logger.error(e.class.to_s + ": " + e.message)
    end

    def get_finder(finder_or_name)
      if finder_or_name.respond_to?(:plugin_files)
        finder_or_name
      else
        Finder::Standard.new(finder_or_name)
      end
    end
  end
end
