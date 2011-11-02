require 'rails/generators'

module HasManyAutocomplete
  class InstallGenerator < Rails::Generators::Base
    def install
      copy_file('javascripts/has-many-autocomplete.js', 'app/assets/javascripts/has-many-autocomplete.js')
    end

    def self.source_root
      File.join(File.dirname(__FILE__), '..', '..', 'assets')
    end
  end
end