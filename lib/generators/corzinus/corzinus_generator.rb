module Corzinus
  class CorzinusGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc 'Generates a migration file, corzinus routes and require assets'

    desc <<-DESC.strip_heredoc
    It do:
      1. add corzinus route
      2. create migration files
      3. require assets
      4. include to ApplicationController corzinus controller methods and helpers
    DESC

    def add_corzinus_routes
      corzinus_route = 'mount Corzinus::Engine'
      return if File.readlines('config/routes.rb').grep(/#{corzinus_route}/).any?
      corzinus_route << " => '/cart'"
      route corzinus_route
    end

    def generate_migrations
      rake 'corzinus:install:migrations'
    end

    def require_javascripts
      path = 'app/assets/javascripts/application.js'
      insert = '//= require corzinus'
      return if File.readlines(path).grep(insert).any?
      inject_into_file path, before: '//= require_tree .' do
        "#{insert}\n"
      end
    end

    def require_stylesheets
      path = 'app/assets/stylesheets/application.css'
      insert = '*= require corzinus'
      return if File.readlines(path).grep(insert).any?
      inject_into_file path, after: ' *= require_self' do
        "\n #{insert}"
      end
    end

    def include_controller_methods
      path = 'app/controllers/application_controller.rb'
      return if File.readlines(path).grep(/include Corzinus::Controllable/).any?
      inject_into_file path, after: 'class ApplicationController < ActionController::Base' do
        insert = "\n"
        insert << "  include Corzinus::Controllable\n"
        insert << "  helper Corzinus::Engine.helpers\n"
      end
    end

    def run_migrations
      return if no? 'Do you want to run Corzinus migrations now?'
      rake 'db:migrate SCOPE=corzinus'
    end
  end
end
