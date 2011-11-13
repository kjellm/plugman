# encoding: utf-8

require 'plugman/black_white_policy'
require 'plugman/gem_finder'
require 'plugman/simple_finder'
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
#   /^signal_(before|after|at)/
#
# plugman will then call similar named (without signal_) methods on all
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
#       @pm.signal_at_starup
#
#       # ...
#    
#       @pm.signal_before_bar
#     end
#

class Plugman

  def initialize(finder_or_name)
    self.finder = finder_or_name
    @plugins = []
    @log = StringIO.new("")
    @logger = Logger.new(@log)
    Plugman::PluginBase.manager = self
    @policy = Plugman::BlackWhitePolicy.new([], []) { |x| true } 
  end

  def log 
    @log.string
  end

  # Looks for plugins, requires them, checks state, initializes, and
  # registers the plugins
  def load_plugins
    @policy.apply(@finder.plugin_files).each do |f|
      require_plugin(f)
    end

    # All plugins are now registered. Requiering the plugins will
    # magically call Plugman::Plugin::inherited for each
    # plugin. inherited() will in turn call register_plugin()

    @plugins = @plugins.select {|p| p.state_ok? }
  end

  # Calls the 
  def method_missing(name, *arguments, &block)
    if name.to_s =~ /^signal_(before|after|at)/
      method = name.to_s[7..-1]
      @logger.debug("Sending #{method} to plugins")
      @plugins.select {|p| p.respond_to?(method)}.each do |p|
        p.send(method, *arguments)
      end
    else
      super
    end
  end

  def register_plugin(klass)
    @plugins.push(klass.new)
  end

  # FIX implement respond_to? to match method_missing?

  private

  def finder=(finder_or_name)
    if finder_or_name.respond_to?(:plugin_files)
      @finder = finder_or_name
    else
      @finder = Finder::Standard.new(finder_or_name)
    end
  end

  def require_plugin(f)
    @logger.debug "Requiering #{f}"
    require f
  rescue => e
    @logger.error(e.class.to_s + ": " + e.message)
  end


end
