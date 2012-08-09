# encoding: utf-8

require 'logger'
require 'plugman/config_loader'
require 'plugman/plugin_base'

class Plugman

  def initialize(args)
    Plugman::PluginBase.manager = self

    @plugins = args[:plugins] || []
    @logger  = args[:logger]
    @loader  = args[:loader]

    if @logger.nil?
      @logger = Logger.new(STDERR)
      @logger.level = Logger::WARN
    end
  end

  def load_plugins
    @loader.call(@logger)
  end

  def notify(event, *arguments, &block)
    @logger.debug("Sending #{event} to plugins")
    @plugins.select {|p| p.respond_to?(event)}.each do |p|
      notify_plugin(p, event, *arguments, &block)
    end
    true
  end

  def register_plugin(klass)
    @plugins.push(klass.new)
  end

  private 

  def notify_plugin(plugin, event, *arguments, &block)
    plugin.send(event, *arguments, &block)
  rescue e
    @logger.error(e)
  end

end
