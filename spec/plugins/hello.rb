require 'plugman/plugin_base'

class Hello < Plugman::PluginBase

  def reset_hello(str)
    @str = str
  end

  def hello(world="")
    @str << "Hello"
    @str << world
    @str << yield if block_given?
  end

end
