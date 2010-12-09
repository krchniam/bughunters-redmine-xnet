require 'rubygems'
require 'rake'

begin
  gem 'jeweler', '~> 1.4'
  require 'jeweler'

  Jeweler::Tasks.new do |gem|
    gem.name = 'redmine_charts'
    gem.summary = 'Plugin for Redmine which integrates some nice project charts.'
    gem.description = gem.summary
    gem.author = 'Maciej Szczytowski'
    gem.email = 'mszczytowski@gmail.com'
    gem.homepage = 'http://github.com/mszczytowski/redmine_charts/'
    gem.files.include('app/**/*.rb')
    gem.files.include('assets/**/*.js')
    gem.files.include('config/**/*.rb')
    gem.files.include('config/**/*.yml')
    gem.files.include('db/**/*.rb')
    gem.files.include('lib/**/*.rb')
    gem.files.include('lib/**/*.rake')
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: gem install jeweler'
end