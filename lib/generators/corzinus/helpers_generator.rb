module Corzinus
  class HelpersGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc 'Generates a helpers files'

    def generate_helpers
      locales_path = Corzinus::Engine.root.join('app', 'helpers', 'corzinus')
      directory locales_path, 'app/helpers/corzinus'
    end
  end
end
