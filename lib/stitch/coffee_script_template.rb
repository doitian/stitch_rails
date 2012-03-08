require 'tilt'

module Stitch
  class CoffeeScriptTemplate < Tilt::Template
    self.default_mime_type = 'application/javascript'

    @@default_bare = false

    def self.default_bare
      @@default_bare
    end

    def self.default_bare=(value)
      @@default_bare = value
    end

    @@excludes = []

    def self.engine_initialized?
      defined? ::CoffeeScript
    end

    def self.excludes=(excludes)
      @@excludes = excludes
    end

    def initialize_engine
      require_template_library 'coffee_script'
    end

    def prepare
      if !options.key?(:bare)
        options[:bare] = self.class.default_bare
      end
    end

    def evaluate(scope, locals, &block)
      name = module_name(scope)
      if (name == 'stitch_rails') || @@excludes.include?(name)
        @output ||= CoffeeScript.compile(data, options)
      else
        @output ||= <<JS
require.define({
  '#{name}': function(exports, require, module) {
#{CoffeeScript.compile(data, options.merge(:bare => true))}
  }
});
JS
      end
    end

    private
    # this might need to be customisable to generate the desired module names
    # this implementation lops off the first segment of the path
    def module_name(scope)
      scope.logical_path
    end
  end
end
