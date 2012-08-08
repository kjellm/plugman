require 'plugman'

describe Plugman do

  # Before each won't work because the plugins can only be required
  # once per process. FIXME maybe a bug?
  before(:all) do
    @log      = StringIO.new("")
    logger    = Logger.new(@log)
    loader    = Plugman::DirLoader.new(logger, File.dirname(__FILE__) + '/plugins')
    @plugman  = Plugman.new(loader, logger)
    @plugman.load_plugins
  end

  it "should log a message when loading a plugin" do
    @log.string.should =~ /Requiering.*plugins\/bar.rb/
    @log.string.should =~ /Requiering.*plugins\/baz.rb/
  end

  it "should send event signals to plugins" do
    str = ""
    @plugman.signal :before_big_bang, str

    str.should =~ /WHOOOP/
    str.should =~ /WHIIIIIIIIIIZZZZZZZZ/
  end

  it "should not fail when signaling an event no plugins can respond to" do
    expect { @plugman.signal(:there_should_be_non_plugins_responding_to_this_event) }.to_not raise_error
  end

end
