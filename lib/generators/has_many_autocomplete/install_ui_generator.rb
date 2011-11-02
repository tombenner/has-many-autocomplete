require 'rails/generators'

module HasManyAutocomplete
  class InstallUiGenerator < Rails::Generators::Base
    def install
      copy_file('javascripts/jquery-ui.js', 'app/assets/javascripts/jquery-ui.js')
      directory('stylesheets/ui-lightness/', 'app/assets/stylesheets/ui-lightness/')
    end

    def self.source_root
      File.join(File.dirname(__FILE__), '..', '..', 'assets')
    end
  end
end