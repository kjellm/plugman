require 'plugman'

describe Plugman::BlackWhitePolicy do
  
  it do
    x = []
    policy = Plugman::BlackWhitePolicy.new(%w(c), %w(a b)) do |unknown|
      x << unknown
      false
    end
    plugin_files = %w(prefix/a prefix/b prefix/c prefix/d)
    policy.apply(plugin_files).should == %w(prefix/a prefix/b)
    x.should == %w(d)
  end
  
  it do
    policy = Plugman::BlackWhitePolicy.new(%w(c), %w(a b)) { |x| true }
    plugin_files = %w(prefix/a prefix/b prefix/c prefix/d)
    policy.apply(plugin_files).should == %w(prefix/a prefix/b prefix/d)
  end
  
end

