
class Plugman

  #
  # Plugins need to inherit this class for plugman to be able register
  # them.
  #
  # A typical plugin will look like something like this:
  #
  #    require 'plugman/plugin_base' 
  #  
  #    class YourApp
  #      module Plugin
  #        class CoolPlugin < Plugman::PluginBase
  #
  #           def at_startup
  #             puts "Whoa, it worked!"
  #           end
  #
  #           def before_bar
  #             puts "foo"
  #           end
  #
  #        end
  #      end
  #    end
  #
  # After a plugin is initialized, plugman will call state_ok?(). Only
  # plugins who return true in this method will be registered by
  # plugman.
  #
  # For documentation on method names, see the documentation for
  # link:Plugman.html
  #

  class PluginBase

    def self.manager=(obj)
      @@manager = obj
    end

    def self.inherited(klass)
      @@manager.register_plugin(klass)
    end

    # Just returns true. Define this in your plugin class if you need
    # to verify that your plugin state is ok after initialization.
    def state_ok?; true; end

  end
end
