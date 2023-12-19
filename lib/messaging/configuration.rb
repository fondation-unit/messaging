# frozen_string_literal: true

module Messaging
  class Configuration
    mattr_accessor :notification_channel,
      :notification_target,
      :notification_count_method,
      :notification_emitter_method,
      :user_class,
      :institution_class,
      :admin_path

    def initialize
      @notification_channel = "default_notification_channel"
      @notification_target = "notifications-count"
      @notification_count_method = nil
      @notification_emitter_method = "message_notification"
      @admin_path = "admin"
    end
  end
end
