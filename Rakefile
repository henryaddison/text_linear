# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "text_linear"
  gem.homepage = "http://github.com/henryaddison/text_linear"
  gem.license = "MIT"
  gem.summary = %Q{Some objects for playing around with text classification via RubyLinear (and liblinear)}
  gem.description = %Q{Some objects for playing around with text classification via RubyLinear (and liblinear)}
  gem.authors = ["Henry Addison"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc "Run specs with SimpleCov"
RSpec::Core::RakeTask.new(:coverage) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  ENV["COVERAGE"] = "true"
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
