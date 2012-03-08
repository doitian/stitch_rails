require 'stitch/coffee_script_template'

module Stitch
  class Railtie < ::Rails::Engine
    config.before_configuration do
      config.stitch = ::Stitch::CoffeeScriptTemplate
    end

    initializer 'stitch.configure_rails_initialization' do |app|
      app.assets.register_engine '.coffee', ::Stitch::CoffeeScriptTemplate
    end
  end
end
