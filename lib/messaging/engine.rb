# frozen_string_literal: true

module Messaging
  class Engine < ::Rails::Engine
    isolate_namespace Messaging

    initializer "messaging.assets.precompile" do |app|
      app.config.assets.paths << root.join("app", "builds").to_s
    end

    config.before_configuration do
      Messaging.configuration ||= Messaging::Configuration.new
    end
  end
end
