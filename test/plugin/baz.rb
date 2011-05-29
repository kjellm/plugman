require 'plugman/plugin_base'

class Baz < Plugman::PluginBase

  def before_big_bang(str)
    str << "WHIIIIIIIIIIZZZZZZZZ\n"
  end

end
