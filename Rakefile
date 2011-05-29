# encoding: utf-8

require 'rake/gempackagetask'
require 'rake/testtask'

load File.dirname(__FILE__) + '/plugman.gemspec'

task :default => ['test']

namespace 'build' do

  Rake::GemPackageTask.new(Spec) do |pkg|
    pkg.need_tar = true
  end

end

Rake::TestTask.new do |t|
  t.name = :test
  t.test_files = FileList['test/*.rb']
end

desc 'Remove generated files and folders'
task :clean => ['build:clobber_package']
