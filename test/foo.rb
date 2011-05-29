require 'plugman'
require 'plugman/finder'
require 'test/unit' 

class Foo < Test::Unit::TestCase

  def test_it
    pm = Plugman.new(Plugman::Finder::Simple.new(File.dirname(__FILE__) + '/plugin'))
    pm.load_plugins
    
    str = ""
    pm.send_before_big_bang(str)
    assert(str =~ /WHOOOP/)
    assert(str =~ /WHIIIIIIIIIIZZZZZZZZ/)
  end

end

