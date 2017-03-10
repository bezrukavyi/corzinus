module Corzinus
  class CorzinusGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc 'Generates a migration file and corzinus routes.'

    def add_corzinus_routes
      corzinus_route = 'mount Corzinus::Engine'
      if File.readlines('config/routes.rb').grep(/#{corzinus_route}/).any?
        puts 'You already have corzinus route'
        return
      end
      corzinus_route << " => '/corzinus'"
      route corzinus_route
    end

    def generate_migrations
      rake 'corzinus:install:migrations'
    end

    def run_migrations
      return if no? 'Do you want to run Corzinus migrations now?'
      rake 'db:migrate SCOPE=corzinus'
    end
  end
end
