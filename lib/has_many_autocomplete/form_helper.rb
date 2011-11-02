module ActionView
  module Helpers
    module FormHelper
      # Returns a text input that will be used as an autocomplete field, a unordered list of associated records, and a hidden
      # multiple select tag which is used to store the associated records' IDs for when the form is submitted.  
      #
      # ==== Examples
      #   f.has_many_autocomplete :song_ids, autocomplete_song_name_playlists_path, @playlist.songs.collect{|s| [s.name, s.id]}, :label => "Add song:"
      #
      def has_many_autocomplete(object_name, method, source, records, options ={})
        input_id = "#{object_name}_#{method}_autocomplete"
        [
          options[:label].blank? ? nil : label_tag(input_id, options[:label]),
          text_field_tag(input_id, nil, hma_text_field_options(source, options)),
          hma_list_tag(records, options),
          hma_select_tag(object_name, method, records)
        ].join.html_safe
      end
    end

    #
    # Transforms has_many_autocomplete options into options that are suitable for a text_field_tag
    #
    private
    def hma_text_field_options(source, options)
      options["data-autocomplete"] = source
      options[:class] = "has-many-autocomplete"
      options.delete(:label)
      options
    end
    
    def hma_select_tag(object_name, method, records)
      selected_values = records.collect {|c| c[1] }
      select_options = options_for_select(selected_values, selected_values)
      select_tag = select_tag("#{object_name}[#{method}]", select_options, :multiple => true, :class => 'hma-hidden-select', :style => 'display: none;')
    end
    
    def hma_list_tag(records, options={})
      defaults = {:remove_text => "Remove"}
      options = defaults.merge(options)
      list_items = records.collect {|c| "
        <li>
          <a href=\"#\" class=\"hma-remove-link\" data-id=\"#{c[1]}\"><span class=\"hma-remove-link-text\">#{options[:remove_text]}</span></a>
          <span class=\"hma-item-label\">#{c[0]}</span>
        </li>"
      }
      "<ul class=\"hma-list\">#{list_items.join}</ul>"
    end
  end
end

class ActionView::Helpers::FormBuilder
  def has_many_autocomplete(method, source, records, options = {})
    @template.has_many_autocomplete(@object_name, method, source, records, objectify_options(options))
  end
end
