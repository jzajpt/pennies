# encoding: utf-8

require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "pennies"
    gem.summary = %Q{Money and Currency handling library.}
    gem.description = %Q{Pennies handles your money and currency needs. Support Mongoid and MongoMapper.}
    gem.email = "jzajpt@blueberry.cz"
    gem.homepage = "http://github.com/jzajpt/pennies"
    gem.authors = ["Jiri Zajpt"]
    gem.files = Dir.glob('lib/**/*.rb')

    gem.add_development_dependency "rspec", "~> 2.1.0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:core) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--backtrace']
end

task :default => :spec



#task :spec => :check_dependencies


# require 'rake/rdoctask'
# Rake::RDocTask.new do |rdoc|
#   version = File.exist?('VERSION') ? File.read('VERSION') : ""
#
#   rdoc.rdoc_dir = 'rdoc'
#   rdoc.title = "pennies #{version}"
#   rdoc.rdoc_files.include('README*')
#   rdoc.rdoc_files.include('lib/**/*.rb')
# end
