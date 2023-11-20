module Messaging
  class Engine < ::Rails::Engine
    isolate_namespace Messaging

    initializer 'messaging.assets.precompile' do |app|
      app.config.assets.paths << root.join('app', 'builds').to_s
    end
  end
end
