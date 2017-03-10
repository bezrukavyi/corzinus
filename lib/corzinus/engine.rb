module Corzinus
  class Engine < ::Rails::Engine
    isolate_namespace Corzinus

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end

    config.to_prepare do
      %w(decorator validator).each do |type|
        paths = [Dir.pwd, "app/#{type.pluralize}/*_#{type}*.rb"]
        Dir.glob(File.join(paths)).each { |file| require file }
      end
    end

    config.assets.paths << File.expand_path('../../assets/stylesheets', __FILE__)
    config.assets.paths << File.expand_path('../../assets/javascripts', __FILE__)

    config.i18n.default_locale = :en
    config.i18n.load_path += Dir[Engine.root.join('config', 'locales', '**', '*.{rb,yml}')]
  end
end
