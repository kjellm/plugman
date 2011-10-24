require 'plugman/plugin_base'

class Bar < Plugman::PluginBase

  def before_big_bang(str)
    str << "WHOOOP\n"
  end

end
