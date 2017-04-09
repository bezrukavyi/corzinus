module Corzinus
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc 'Creates a Corzinus initializer and copy locale files to your' \
         'application.'

    def create_initialize_file
      template 'corzinus.rb', 'config/initializers/corzinus.rb'
    end

    def copy_locales
      locales_path = Corzinus::Engine.root.join('config', 'locales', 'corzinus')
      directory locales_path, 'config/locales/corzinus'
    end
  end
end
