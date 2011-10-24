# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "plugman/version"

Gem::Specification.new do |s|

  s.required_ruby_version     = '>= 1.9.2'
  s.required_rubygems_version = ">= 1.4.0"

  s.name        = 'plugman'
  s.platform    = Gem::Platform::RUBY
  s.version     = Plugman::VERSION
  s.summary     = 'A plugin manager.'
  s.description = 'Plugman is a plugin manager that supports event driven communication with plugins. It handles the loading, initialization and all communications with the plugins.'
  s.homepage    = 'http://github.com/kjellm/plugman'
  s.author      = 'Kjell-Magne Øierud'
  s.email       = 'kjellm@acm.org'

  s.files = Dir.glob('lib/**/*.rb') + 
    Dir.glob('test/**/*.rb') + 
    %w(Rakefile README.md)
    
  s.add_development_dependency "rspec"

end

