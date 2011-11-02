module HasManyAutocomplete
  module Orm
    autoload :ActiveRecord , 'has_many_autocomplete/orm/active_record'
	autoload :Mongoid      , 'has_many_autocomplete/orm/mongoid'
	autoload :MongoMapper  , 'has_many_autocomplete/orm/mongo_mapper'
  end
end

