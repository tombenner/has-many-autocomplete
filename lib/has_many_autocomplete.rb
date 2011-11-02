require 'has_many_autocomplete/form_helper'
require 'has_many_autocomplete/autocomplete'
require 'has_many_autocomplete/model/active_record'

module HasManyAutocomplete
  autoload :Orm              , 'has_many_autocomplete/orm'
  autoload :FormtasticPlugin , 'has_many_autocomplete/formtastic_plugin'
end

class ActionController::Base
  include HasManyAutocomplete::Autocomplete
end