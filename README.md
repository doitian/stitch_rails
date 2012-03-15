# stitch_rails

Inspired by <https://gist.github.com/1153919>

Brings `require` to Rails Sprockets.

All `.coffee` file will be wrapped as `require.define`.

`require("foo/bar")` will load file `app/assets/javascripts/foo/bar.js.coffee` and execute it.

## Example

**Gemfile**:

    gem 'stitch_rails', '0.0.3'


**config/application.rb**:

```ruby
module YourApp
  class Application < Rails::Application
    # .... omit ....

    # file names listed here are not wraped in `require.define`, so they
    # are executed immediatly. Handy for an app start point. Otherwise you
    # have add an .js file to require your start file. Suffix should not be added here.
    # Glob pattern is also supported.
    config.stitch.excludes = %w(application *_spec jasminerice)
  end
end
```

**app/assets/javascripts/application.js.coffee**:

```coffee-script
# These are sprockets require that used to includes js files. Since
# .coffee file are wrapped as module, the js code is only executed when
# javascript function `require` is invoked.
#
#= require jquery
#
# Must load stitch_rails before any other coffee file, it defines the global method `require`
#
#= require stitch_rails
#= require_tree ./
#= require_this
#
# Since this file is in stitch excludes, code here are executed when it is loaded:

$ ->
  Greet = require('models/greet')
  greet = new Greet()
  greet.sayHi()
```

***app/assets/javascripts/models/greet.js.coffee***

```coffee-script
class Greet
  sayHi: ->
    alert 'Hello, World'

module.exports = Greet
```

See more about CommonJS module in <http://wiki.commonjs.org/wiki/Modules/1.1>

## TODO

- Make it work for Sprockets without Rails 

