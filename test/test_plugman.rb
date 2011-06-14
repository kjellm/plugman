require 'plugman'
require 'plugman/finder'
require 'test/unit' 

class TestPlugman < Test::Unit::TestCase

  def test_it
    pm = Plugman.new(Plugman::Finder::Simple.new(File.dirname(__FILE__) + '/plugin'))
    pm.load_plugins
    
    str = ""
    pm.signal_before_big_bang(str)
    print pm.log

    assert(str =~ /WHOOOP/)
    assert(str =~ /WHIIIIIIIIIIZZZZZZZZ/)

    assert_raise NoMethodError do
      pm.this_should_be_missing
    end
  end

end

