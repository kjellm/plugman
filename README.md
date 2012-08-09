Plugman [![Build Status](https://secure.travis-ci.org/kjellm/plugman.png)](http://travis-ci.org/kjellm/plugman) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/kjellm/plugman)
=======

Plugman is a plugin manager that supports event driven communication
with plugins. It handles the loading, initialization and all
communications with the plugins.


Why use plugman?
----------------

Plugman's event driven approach lets you completely decouple the
application from the plugins. This is in my opinion a major advantage
because it lets you factor out functionality into plugins without much
added complexity.

There are several plugin managers available from RubyGems.org, but
none seems to let you use events as the means of communication. (The
ones that I have looked at are: plugin, gem\_plugin, little\_plugger,
plugin\_manager, and plugin-loader)


Installation
------------

The easiest way to get plugman is through rubygems

    gem install plugman

or you can get it from <https://github.com/kjellm/plugman>.


Usage
-----

### Minimal Example

    ```ruby
    require 'plugman'

    class APlugin
     
      def hello_world
        puts "Hello World!"
      end
          
    end

    class TheApp

      def initialize
        @plugman = Plugman.new(plugins: [APlugin.new])
      end
      
      def main
        @plugman.notify :hello_world
      end

    end
    ```

### Using a Loader to load plugins

Note: Plugins that are to be loaded by plugman need to extend
Plugman::PluginBase.

In the minimal example, the application did all the loading and
initialization of the plugins. This is not very flexible. What you
usually would rather do is to initialize Plugman with a Loader to
handle all this.

Here's an example using the provided ConfigLoader:

    # $HOME/.app.yml
    ---
    :plugins : ['app/plugin/logger']
    
```ruby
# app/lib/app.rb
require 'plugman'
require 'yaml'

class App

  def initialize
    rc = YAML.load_file("#{ENV['HOME']}/.app.yml")
    @plugman = Plugman.new(loader: Plugman::ConfigLoader.new(rc[:plugins]))
    @plugman.load_plugins
  end
  
  def main
    @plugman.notify :system_launched
    # ...
  end
  
end


# app-plugin-logger/lib/app/plugin/logger.rb
require 'logger'

class App
  module Plugin
    class Logger < Plugman::PluginBase
    
      def initialize
        @logger = ::Logger.new(STDERR)
      end
    
      def system_launched
        @logger.info "The system has launched!"
      end
        
    end
  end
end
```

### Passing extra information to the plugins when you notify them about events

Plugman lets you send arguments and/or blocks to plugins when calling #notify.
Here is how it works:

```ruby
# In a plugin:
def hello(world="")
    str = "Hello" << world
    str << yield if block_given?
    puts str
end

# Somewhere in the app:
@plugman.notify(:hello)                    # => "Hello"
@plugman.notify(:hello, " world")          # => "Hello world"
@plugman.notify(:hello, " world") { "!" }  # => "Hello world!"
@plugman.notify(:hello) { "!" }            # => "Hello!"
```

### Creating your own loader

You can easily create your own loader as a Loader is nothing but an
callable object (it responds to #call.)

Here is one that loads all ruby files in a directory:

```ruby
->(a) { Dir.glob('/plugins/are/here/*.rb').each {|f| require f}}
```

And here is one that uses Gem.find_files

```ruby
->(a) do
  seen = {}
  Gem.find_files('the_app/plugin/*', true).each do |f|
    name = File.basename(f)
    require name unless seen[f]
    seen[f] = true
  end
end
```


Bugs
----

Report bugs to <https://github.com/kjellm/plugman/issues>.


Author
------

Kjell-Magne Øierud &lt;kjellm AT oierud DOT net&gt;

License
-------

(The MIT License)

Copyright © 2011-2012 Kjell-Magne Øierud

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the ‘Software’), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial
portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
