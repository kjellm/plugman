# encoding: utf-8

require 'plugman/finder'
require 'plugman/plugin_base'
require 'logger'
require 'stringio'

class Plugman

  def initialize(finder)
    @finder  = finder
    @plugins = []
    @log = StringIO.new("")
    @logger = Logger.new(@log)
    Plugman::PluginBase.manager = self
  end

  def log 
    @log.string
  end

  def load_plugins
    @finder.plugin_files.each do |f|
      require_plugin(f)
    end

    # All plugins are now registered. Requiering the plugins will
    # magically call Plugman::Plugin::inherited for each
    # plugin. inherited() will in turn call register_plugin()

    @plugins = @plugins.select {|p| p.state_ok? }
  end

  def register_plugin(klass)
    @plugins.push(klass.new)
  end

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


  def require_plugin(f)
    @logger.debug "Requiering #{f}"
    require f
  rescue => e
    @logger.error(e.class.to_s + ": " + e.message)
  end


end
