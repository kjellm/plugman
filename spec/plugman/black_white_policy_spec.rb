require 'plugman'

describe Plugman::BlackWhitePolicy do
  
  it do
    x = []
    policy = Plugman::BlackWhitePolicy.new(%w(c), %w(a b)) do |unknown|
      x << unknown
      false
    end
    policy.apply(%w(a b c d)).should == %w(a b)
    x.should == %w(d)
  end
  
end

