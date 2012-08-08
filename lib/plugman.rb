# encoding: utf-8

require 'plugman/black_white_policy'
require 'plugman/gem_finder'
require 'plugman/simple_finder'
require 'plugman/plugin_base'
require 'plugman/gem_loader'
require 'logger'
require 'stringio'

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
#       @pm.signal :at_starup
#
#       # ...
#
#       @pm.signal :before_bar
#     end
#

class Plugman

  def initialize(loader, logger=Logger.new, loader_maker=GemLoader.method(:new))
    # self.finder = finder_or_name
    @plugins = []
    @logger  = logger
    Plugman::PluginBase.manager = self
    @loader = loader_maker.call(@logger)
  end

  def load_plugins
    @loader.load_plugins
  end

  def signal(message, *arguments, &block)
    @logger.debug("Sending #{message} to plugins")
    @plugins.select {|p| p.respond_to?(message)}.each do |p|
      p.send(message, *arguments)
    end
  end

  def register_plugin(klass)
    @plugins.push(klass.new)
  end

end
