# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
# Prevent database truncation if the environment is production
if Rails.env.production?
  abort('The Rails environment is running in production mode!')
end
require 'spec_helper'
require 'rspec/rails'
require 'rectify/rspec'
require 'with_model'
require 'aasm/rspec'
require 'capybara/rspec'
require 'capybara/email/rspec'
require 'capybara-screenshot/rspec'
require 'capybara/poltergeist'

ENGINE_ROOT = File.join(File.dirname(__FILE__), '../')
%w(support factories).each do |folder|
  Dir[File.join(ENGINE_ROOT, "spec/#{folder}/**/*.rb")].each do |file|
    require file
  end
end

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include Shoulda::Matchers::ActiveModel
  config.include Shoulda::Matchers::ActiveRecord
  config.include FactoryGirl::Syntax::Methods
  config.include Rectify::RSpec::Helpers
  config.include I18n
  config.extend WithModel

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  Capybara.register_driver :selenium_chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end
  Capybara::Webkit.configure(&:block_unknown_urls)

  Capybara.javascript_driver = :poltergeist
  # Capybara.javascript_driver = :selenium_chrome

  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  Shoulda::Matchers.configure do |matcher_config|
    matcher_config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
end
