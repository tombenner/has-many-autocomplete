$(document).ready(function(){
  $('input.has-many-autocomplete').hasManyAutocomplete();
});

(function(jQuery)
{
  var self = null;
  jQuery.fn.hasManyAutocomplete = function() {
    if (!this.hasManyAutocompleter) {
      this.hasManyAutocompleter = new jQuery.hasManyAutocomplete(this);
    }
  };

  jQuery.hasManyAutocomplete = function (e) {
    _e = e;
    this.init(_e);
  };

  jQuery.hasManyAutocomplete.fn = jQuery.hasManyAutocomplete.prototype = {
    hasManyAutocomplete: '0.0.1'
  };

  jQuery.hasManyAutocomplete.fn.extend = jQuery.hasManyAutocomplete.extend = jQuery.extend;
  jQuery.hasManyAutocomplete.fn.extend({
    init: function(e) {
    
      e.delimiter = $(e).attr('data-delimiter') || null;
      e.list_element = $(e).find('~ ul.hma-list');
      e.select_element = $(e).find('~ select.hma-hidden-select');
      
      function split( val ) {
        return val.split( e.delimiter );
      }
      
      function extractLast( term ) {
        return split( term ).pop().replace(/^\s+/,"");
      }
      
      function updateHiddenSelect() {
        var id;
        ids = [];
        e.select_element.find('option').remove();
        e.list_element.find('.hma-remove-link').each(function() {
          id = $(this).attr('data-id');
          appendOptionToHiddenSelect( id );
        });
      }
      
      function appendOptionToHiddenSelect( id ) {
          e.select_element.append('<option value="'+id+'" selected="selected">'+id+'</option>');
      }
      
      e.list_element.sortable({
        stop: function(event, ui) {
          updateHiddenSelect();
        }
      });
      
      e.list_element.find('.hma-remove-link').live('click', function() {
        var id = $(this).attr('data-id');
        $(this).parents('li:first').remove();
        updateHiddenSelect();
        return false;
      });

      $(e).autocomplete({
        source: function( request, response ) {
          $.getJSON( $(e).attr('data-autocomplete'), {
            term: extractLast( request.term )
          }, function() {
            $(arguments[0]).each(function(i, el) {
              var obj = {};
              obj[el.id] = el;
              $(e).data(obj);
            });
            response.apply(null, arguments);
          });
        },
        search: function() {
          // custom minLength
          var term = extractLast( this.value );
          if ( term.length < 2 ) {
            return false;
          }
        },
        focus: function() {
          // prevent value inserted on focus
          return false;
        },
        select: function( event, ui ) {
          e.list_element.append('<li><a href="#" class="hma-remove-link" data-id="'+ui.item.id+'"><span class="hma-remove-link-text">Remove</a> <span class="hma-item-label">'+ui.item.label+'</span></li>');
          appendOptionToHiddenSelect( ui.item.id );
          $(this).val('');
          $(this).trigger('hasManyAutocomplete.select', ui);
          return false;
        }
      });
    }
  });
})(jQuery);