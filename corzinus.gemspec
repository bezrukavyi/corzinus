$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "corzinus/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'corzinus'
  s.version     = Corzinus::VERSION
  s.authors     = ['Yaroslav Bezrukavyi']
  s.email       = ['yaroslav555@gmail.com']
  s.homepage    = "http://amazon555.herokuapp.com"
  s.summary     = 'Summary of Corzinus.'
  s.description = 'Simple cart for your store'
  s.license     = 'MIT'

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'rails', '~> 5.0.1'
  s.add_dependency 'aasm'
  s.add_dependency 'wicked'
  s.add_dependency 'rectify'
  s.add_dependency 'cancancan'
  s.add_dependency 'draper'
  s.add_dependency 'credit_card_validations'

  s.add_development_dependency "pg"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'with_model'
end
