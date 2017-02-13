# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
# Prevent database truncation if the environment is production
if Rails.env.production?
  abort('The Rails environment is running in production mode!')
end
require 'spec_helper'
require 'rspec/rails'
require 'shoulda-matchers'
require 'aasm/rspec'
require 'with_model'
require 'rectify/rspec'

ENGINE_ROOT = File.join(File.dirname(__FILE__), '../')
%w(support factories).each do |folder|
  Dir[File.join(ENGINE_ROOT, "spec/#{folder}/**/*.rb")].each do |file|
    require file
  end
end

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include I18n
  config.extend WithModel

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  Capybara.javascript_driver = :poltergeist

  config.use_transactional_fixtures = false
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    driver_test = Capybara.current_driver == :rack_test
    driver_shares_db_connection_with_specs = driver_test
    unless driver_shares_db_connection_with_specs
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
