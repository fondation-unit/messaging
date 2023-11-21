# frozen_string_literal: true

module Messaging
  class Engine < ::Rails::Engine
    isolate_namespace Messaging

    initializer "messaging.assets.precompile" do |app|
      app.config.assets.precompile << "config/manifest.js"
    end

    config.before_configuration do
      Messaging.configuration ||= Messaging::Configuration.new
    end
  end
end
