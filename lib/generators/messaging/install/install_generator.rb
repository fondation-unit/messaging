# frozen_string_literal: true

module Messaging
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../../", __dir__)

      def copy_files
        directory "app/views", "app/views"
        copy_file "config/initializers/messaging.rb", "config/initializers/messaging.rb"
      end
    end
  end
end
