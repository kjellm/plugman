# encoding: utf-8

require 'plugman/finder'
require 'plugman/plugin_base'
require 'logger'
require 'stringio'

#
# Plugman is a plugin manager that supports event driven communication
# with plugins. It handles the loading, initialization and all
# communications with the plugins.
#
# To call a method on the registered plugins, call plugman with a
# method name matching 
# 
#   /^send_(before|after|at|.*_hook$)/
#
# plugman will then call similar named (without send_) methods on all
# plugins which responds to the method.
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
#       @pm.send_at_starup
#
#       # ...
#    
#       @pm.send_before_bar
#     end
#

class Plugman

  def initialize(finder_or_name)
    self.finder = finder_or_name
    @plugins = []
    @log = StringIO.new("")
    @logger = Logger.new(@log)
    Plugman::PluginBase.manager = self
  end

  def log 
    @log.string
  end

  # Looks for plugins, requires them, checks state, initializes, and
  # registers the plugins
  def load_plugins
    @finder.plugin_files.each do |f|
      require_plugin(f)
    end

    # All plugins are now registered. Requiering the plugins will
    # magically call Plugman::Plugin::inherited for each
    # plugin. inherited() will in turn call register_plugin()

    @plugins = @plugins.select {|p| p.state_ok? }
  end

  # Calls the 
  def method_missing(name, *arguments, &block)
    if name.to_s =~ /^send_(before|after|at|.*_hook$)/
      method = name.to_s[5..-1]
      @plugins.select {|p| p.respond_to?(method)}.each do |p|
        p.send(method, *arguments)
      end
    else
      super
    end
  end

  # FIX implement respond_to? to match method_missing?

  private

  def register_plugin(klass)
    @plugins.push(klass.new)
  end

  def finder=(finder_or_name)
    if finder_or_name.is_a?(String)
      @finder = Finder::Standard.new(finder_or_name)
    elsif finder_or_name.respond_to?(:plugin_files)
      @finder = finder_or_name
    else
      raise ArgumentError 'Require a string or an object repsonding to plugin_files()'
    end
  end

  def require_plugin(f)
    @logger.debug "Requiering #{f}"
    require f
  rescue => e
    @logger.error(e.class.to_s + ": " + e.message)
  end


end
