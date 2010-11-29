require 'rubygems'
require 'rake'
require 'bundler'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rack-mongrel2"
    gem.summary = %Q{The only Mongrel2 Rack handler you'll ever need.}
    gem.description = %Q{A Rack handler for the Mongrel2 web server, by Zed Shaw. http://mongrel2.org/}
    gem.email = 'darkhelmet@darkhelmetlive.com'
    gem.homepage = 'http://github.com/darkhelmet/rack-mongrel2'
    gem.authors = ['Daniel Huckstep']
    gem.add_bundler_dependencies
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.ruby_opts = ['-Ilib', '-Ispec']
  t.pattern = 'spec/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:rcov) do |t|
  t.ruby_opts = ['-Ilib', '-Ispec']
  t.pattern = 'spec/**/*_spec.rb'
  t.rcov = true
end

# task :spec => :check_dependencies

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort 'YARD is not available. In order to run yardoc, you must: `gem i yard`'
  end
end