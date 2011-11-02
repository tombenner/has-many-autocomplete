$:.push File.expand_path("../lib", __FILE__)

require "has_many_autocomplete/version"

Gem::Specification.new do |s|
  s.name        = "has-many-autocomplete"
  s.version     = HasManyAutocomplete::VERSION
  s.authors     = ["Tom Benner"]
  s.homepage    = "http://github.com/tombenner/has-many-autocomplete"
  s.summary     = "Autocomplete and sortable list for has_many associations"
  s.description = "Provides a form helper method that displays a sortable list of associated records from a has_many association and an autocomplete field that can be used to add records to the list."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.0"
end
