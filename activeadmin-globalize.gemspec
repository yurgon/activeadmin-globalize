$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'active_admin/globalize/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'activeadmin-globalize'
  s.version     = ActiveAdmin::Globalize::VERSION
  s.authors     = ['Stefano Verna']
  s.email       = ['stefano.verna@gmail.com']
  s.homepage    = 'http://github.com/stefanoverna/activeadmin-globalize'
  s.summary     = 'Handles globalize translations'
  s.description = 'Handles globalize translations'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'README.md']

  s.add_dependency 'activeadmin'
  s.add_dependency 'globalize', '>= 3.0.4'

  # development dependencies
  s.add_development_dependency 'bundler', '~> 1.6.1'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'sqlite3', '~> 1.3.5'
  s.add_development_dependency 'rspec-rails', '~> 2.14.0'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'capybara', '~> 2.1.0'

end

