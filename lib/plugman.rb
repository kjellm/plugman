# encoding: utf-8

require 'plugman/finder'
require 'plugman/plugin_base'

class Plugman

  def initialize(finder)
    @finder  = finder
    @plugins = []
    Plugman::PluginBase.manager = self
  end

  def load_plugins
    begin
      @finder.plugin_files.each {|f| require f }
    rescue => e
      warn e
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

end
