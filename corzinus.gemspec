$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "corzinus/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'corzinus'
  s.version     = Corzinus::VERSION
  s.authors     = ['Yaroslav Bezrukavyi']
  s.email       = ['yaroslav555@gmail.com']
  s.homepage    = "https://github.com/bezrukavyi/corzinus/tree/Dev"
  s.summary     = 'Summary of Corzinus.'
  s.description = 'Simple cart-checkout for your store'
  s.license     = 'MIT'

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'rails', '~> 5.0.1'
  s.add_dependency 'drape'
  s.add_dependency 'aasm'
  s.add_dependency 'wicked'
  s.add_dependency 'rectify'
  s.add_dependency 'cancancan'
  s.add_dependency 'credit_card_validations'
  s.add_dependency 'rails-i18n'
  s.add_dependency 'haml'
  s.add_dependency 'simple_form'
  s.add_dependency 'bootstrap-sass'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'coffee-rails', '~> 4.2'
  s.add_dependency 'turbolinks', '~> 5'
  s.add_dependency 'chartkick'
  s.add_dependency 'highcharts-rails'

  s.add_development_dependency 'pg', '~> 0.18'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'cancancan'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'capybara-email'
  s.add_development_dependency 'capybara-screenshot'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rectify'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'with_model'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'overcommit'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'brakeman'
  s.add_development_dependency 'rails-controller-testing'
  s.add_development_dependency 'letter_opener_web'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'capybara-webkit'
  s.add_development_dependency 'rails_best_practices'
end
