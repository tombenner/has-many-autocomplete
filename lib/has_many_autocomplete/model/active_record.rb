module HasManyAutocomplete
  module Model
    module ActiveRecord

      extend ActiveSupport::Concern

      included do
        before_save :check1
      end
      
      module ClassMethods
        def has_ordered_many(associations, options = {})
          #name = 'asd'
          after_initialize :init
          class_inheritable_accessor :ordered_has_many_associations
          attr_accessor :videos_changed
          self.ordered_has_many_associations = associations
          self.after_add_for_videos.push(:after_videos_change)
          #attr_accessor :yaffle_text_field
          #self.yaffle_text_field = (options[:yaffle_text_field] || :last_squawk).to_s
        end
        
        def writer(records)
          # Something like this to tell replace_records to create new records (?)
          #records.each {|r| r.touch }
          replace_records(records)
        end
      end
      
      def init
        self.videos_changed = false
      end
      
      def check1
        #self.title = 'fdsss'
      end
      
      def after_videos_change(object)
        self.videos_changed = true
      end


    end
  end
end

ActiveRecord::Base.send :include, HasManyAutocomplete::Model::ActiveRecord