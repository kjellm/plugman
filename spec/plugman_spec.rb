require 'plugman'
require 'plugman/finder'

describe Plugman do

  # Before each won't work because the plugins can only be required once per process. FIXME maybe a bug?
  before(:all) do
    @plugman = Plugman.new(Plugman::Finder::Simple.new(File.dirname(__FILE__) + '/plugins'))
    @plugman.load_plugins
  end

  it "should log a message when loading a plugin" do
    @plugman.log.should =~ /Requiering.*plugins\/bar.rb/
    @plugman.log.should =~ /Requiering.*plugins\/baz.rb/
  end

  it "should send event signals to plugins" do
    str = ""
    @plugman.signal_before_big_bang(str)
    
    str.should =~ /WHOOOP/
    str.should =~ /WHIIIIIIIIIIZZZZZZZZ/
  end    
  
  it "should fail when trying to signal an event no plugins can respond to" do
    # FIXME: Bad decision? This will happen with every event when no plugins are loaded.
    expect { @plugman.this_should_be_missing }.to raise_error(NoMethodError)
  end

end