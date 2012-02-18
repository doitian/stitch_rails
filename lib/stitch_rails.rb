module Stitch
  class StitchyCoffeeScriptTemplate < Tilt::Template
    self.default_mime_type = 'application/javascript'

    def self.engine_initialized?
      defined? ::CoffeeScript
    end

    def initialize_engine
      require_template_library 'coffee_script'
    end

    def prepare
      options[:bare] = true
    end

    def evaluate(scope, locals, &block)
      @output ||= "\nrequire.define({'#{ module_name(scope) }': function(exports, require, module) {\n" + CoffeeScript.compile(data, options) + "\n}});\n"
    end

    private
    # this might need to be customisable to generate the desired module names
    # this implementation lops off the first segment of the path
    def module_name(scope)
      scope.logical_path
    end
  end

  class Railtie < ::Rails::Engine
    initializer 'stitch.configure_rails_initialization' do |app|
      app.assets.register_engine '.coffee', StitchyCoffeeScriptTemplate
    end
  end
end
