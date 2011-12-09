require 'plugman'

module Gem
  def self.find_files(*whatever)
    %w(a b a b b c)
  end
end

describe Plugman::GemFinder do
  
  before(:each) do
    @finder = Plugman::GemFinder.new('')
  end
  
  it do
    @finder.plugin_files.should == %w(a b c)
  end
  
end
