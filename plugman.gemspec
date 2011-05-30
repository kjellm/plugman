# encoding: utf-8

Spec = Gem::Specification.new do |s|

  s.required_ruby_version = '>= 1.8.1'

  s.platform    = Gem::Platform::RUBY
  s.name        = 'plugman'
  s.version     = begin
                    v = '0.1'
                    origin_master_commits = `git rev-list origin/master`.split("\n")
                    v << '.' << origin_master_commits.length.to_s
                  end
  s.summary     = 'A plugin manager.'
  s.description = 'FIX'
  s.homepage    = 'http://github.com/kjellm/plugman'
  s.author      = 'Kjell-Magne Øierud'
  s.email       = 'kjellm@acm.org'

  # s.add_dependency('Foo', '>= 1.0.0')
  s.requirements << 'none'

  s.files = Dir.glob('lib/**/*.rb') + 
    Dir.glob('test/**/*.rb') + 
    %w(Rakefile README.md COPYING)

end

