# Has Many Autocomplete

Provides a form helper method that displays a sortable list of associated records from a has_many association and an autocomplete field that can be used to add records to the list.

Has Many Autocomplete has only been tested on Rails 3.1.

## Installation

Include the gem on your Gemfile

    gem 'has-many-autocomplete', :git => 'git://github.com/tombenner/has-many-autocomplete'

Install it

    bundle install

Run the generator

    rails g has_many_autocomplete:install

jQuery UI needs to be included, either through Google's CDN:

    stylesheet_link_tag "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.8/themes/ui-lightness/jquery-ui.css"
    javascript_include_tag "https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js"

Or by installing the files and including them:

    rails g has_many_autocomplete:install_ui

    stylesheet_link_tag "ui-lightness/jquery-ui"
    javascript_include_tag "jquery-ui.min"

Finally, include has-many-autocomplete.js in your layout after jQuery and jQuery UI:

    javascript_include_tag "jquery", "jquery-ui", "has-many-autocomplete"

## Usage

### Model

We'll assume you have a Playlist model that has_many Songs through PlaylistsSong, and that you want to add Songs to a Playlist via the autocomplete:

    class Playlist < ActiveRecord::Base
      has_many :playlists_songs, :dependent => :destroy
      has_many :songs, :through => :playlists_songs, :order => "playlists_songs.id"
    end

    class PlaylistsSong < ActiveRecord::Base
      belongs_to :playlist
      belongs_to :song
    end

    # Song has a name:string column, which will be used in the autocomplete lookups
    class Song < ActiveRecord::Base
    end

### Controller

To set up the action that the autocomplete uses in your controller, call _autocomplete_ with the model name and the method:

    class PlaylistsController < ApplicationController
      autocomplete :song, :name
    end

This will create an _autocomplete_song_name_ action in your controller, which you'll need to add into routes.rb:

    resources :playlists do
      get :autocomplete_song_name, :on => :collection
    end

Note: To preserve the order of the songs, you'll need to set `@playlist.songs = []` in the _PlaylistsController#update_ action:

    def update
      @playlist = Playlist.find(params[:id])
      @playlist.songs = []
      respond_to do |format|
        # etc...
      end
    end

### Autocomplete Options

#### :full => true

By default, the search starts from the beginning of the string you're searching for. If you want to do a full search, set the _full_ parameter to true.

    class ProductsController < ApplicationController
      autocomplete :song, :name, :full => true
    end

The following terms would match the query 'un':

* Luna
* Unacceptable
* Rerun

#### :full => false (default behavior)

Only the following terms mould match the query 'un':

* Unacceptable

#### :extra_data

By default, your search will only return the required columns from the database needed to populate your form, namely id and the column you are searching (name, in the above example).

Passing an array of attributes/column names to this option will fetch and return the specified data.

    class SongsController < ApplicationController
      autocomplete :song, :name, :extra_data => [:slogan]
    end

#### :display_value

If you want to display a different version of what you're looking for, you can use the :display_value option.

This options receives a method name as the parameter, and that method will be called on the instance when displaying the results.

    class Song < ActiveRecord::Base
      def funky_method
        "#{self.name}.camelize"
      end
    end

    class PlaylistsController < ApplicationController
      autocomplete :song, :name, :display_value => :funky_method
    end

In the example above, you will search by _name_, but the autocomplete list will display the result of _funky_method_

This wouldn't really make much sense unless you use it with the "id_element" attribute. (See below)

Only the object's id and the column you are searching on will be returned in JSON, so if your display_value method requires another parameter, make sure to fetch it with the :extra_data option


#### :scopes
  Added option to use scopes. Pass scopes in an array.
  e.g `:scopes => [:scope1, :scope2]`

#### :column_name
   By default autocomplete uses method name as column name. Now it can be specified using column_name options
   `:column_name => 'name'`

#### json encoder
Yajl is used as the default JSON encoder, but you can specify your own:

    class PlaylistsController < ApplicationController
      autocomplete :song, :name do |items|
         CustomJSON::Encoder.encode(items)
      end
    end

### View

In the form, the following method will display both the autocomplete and the sortable list of songs:

    form_for @playlist do |f|
      f.has_many_autocomplete :song_ids, autocomplete_song_name_playlists_path, @playlist.songs.collect{|s| [s.name, s.id]}
    end

# Thanks

A great deal of this code was based on or taken from the excellent [rails3-jquery-autocomplete](https://github.com/crowdint/rails3-jquery-autocomplete), so a hearty thanks goes to [that project's contributors](https://github.com/crowdint/rails3-jquery-autocomplete/contributors).