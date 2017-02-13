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
  end
end
