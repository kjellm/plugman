# encoding: utf-8

require 'plugman/plugin_base'
require 'plugman/config_loader'
require 'plugman/dir_loader'
require 'logger'

#
# Plugman is a plugin manager that supports event driven communication
# with plugins. It handles the loading, initialization and all
# communications with the plugins.
#
# To notify plugins about an event, call plugman's #signal method
#
# === Example
#
# Put some plugins in lib/your_app/plugin/. For documentation on
# writing plugins, see link:Plugman/PluginBase.html
#
#   require 'plugman'
#
#   class YourApp
#
#     def initialize
#       @pm = Plugman.new('your_app')
#       @pm.load_plugins
#     end
#
#     def main
#       @pm.signal :at_startup
#
#       # ...
#
#       @pm.signal :before_bar
#     end
#

class Plugman

  def initialize(loader, logger=Logger.new(STDERR))
    @plugins = []
    @logger  = logger
    Plugman::PluginBase.manager = self
    @loader = loader
  end

  def load_plugins
    @loader.load_plugins
  end

  def signal(message, *arguments, &block)
    @logger.debug("Sending #{message} to plugins")
    @plugins.select {|p| p.respond_to?(message)}.each do |p|
      p.send(message, *arguments, &block)
    end
  end

  def register_plugin(klass)
    @plugins.push(klass.new)
  end

end
