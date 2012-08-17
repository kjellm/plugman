class Plugman
  class PluginBase

    def self.manager=(obj)
      @@manager = obj
    end

    def self.inherited(klass)
      @@manager.register_plugin(klass)
    end

  end
end
