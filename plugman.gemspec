# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "plugman/version"

Gem::Specification.new do |s|

  s.required_ruby_version     = '>= 1.9.2'

  s.name        = 'plugman'
  s.version     = Plugman::VERSION
  s.summary     = 'A plugin manager.'
  s.description = 'Plugman is a plugin manager that supports event driven communication with plugins. It handles the loading, initialization and all communications with the plugins.'
  s.homepage    = 'http://github.com/kjellm/plugman'
  s.author      = 'Kjell-Magne Øierud'
  s.email       = 'kjellm@oierud.net'

  s.files = Dir.glob('lib/**/*.rb') + 
    Dir.glob('spec/**/*.rb') + 
    %w(CHANGES Gemfile README.md Rakefile)
    
end

