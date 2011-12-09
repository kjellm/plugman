require 'plugman'

describe Plugman do

  # Before each won't work because the plugins can only be required once per process. FIXME maybe a bug?
  before(:all) do
    @plugman = Plugman.new(Plugman::SimpleFinder.new(File.dirname(__FILE__) + '/plugins'))
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
  
  it "should not fail when trying to signal an event no plugins can respond to" do
    expect { @plugman.signal_at_this_should_be_missing }.to_not raise_error
  end

end