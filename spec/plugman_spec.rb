require 'plugman'

describe Plugman do

  # Before each won't work because the plugins can only be required
  # once per process. FIXME maybe a bug?
  before(:all) do
    @log      = StringIO.new("")
    loader    = ->(a) { Dir.glob(File.dirname(__FILE__) + '/plugins/*').each {|f| require f}}
    @plugman  = Plugman.new(loader: loader, logger: Logger.new(@log))
    @plugman.load_plugins
  end

  it "should send events to plugins" do
    str = ""
    @plugman.notify :before_big_bang, str

    str.should =~ /WHOOOP/
    str.should =~ /WHIIIIIIIIIIZZZZZZZZ/
  end

  context "different arguments to #notify" do
    it "should handle no arguments" do
      str = ""
      @plugman.notify :reset_hello, str
      @plugman.notify :hello
      str.should == "Hello"
    end

    it "should pass on arguments" do
      str = ""
      @plugman.notify :reset_hello, str
      @plugman.notify :hello, " world"
      str.should  == "Hello world"
    end

    it "should pass on arguments and block" do
      str = ""
      @plugman.notify :reset_hello, str
      @plugman.notify(:hello, " world") { "!" }
      str.should  == "Hello world!"
    end

    it "should pass on block" do
      str = ""
      @plugman.notify :reset_hello, str
      @plugman.notify(:hello) { "!" } 
      str.should  == "Hello!"
    end

  end

  it "should not fail when signaling an event no plugins can respond to" do
    expect { @plugman.notify(:there_should_be_non_plugins_responding_to_this_event) }.to_not raise_error
  end

end
