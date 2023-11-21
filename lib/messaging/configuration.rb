# frozen_string_literal: true

module Messaging
  class Configuration
    mattr_accessor :notification_channel, :notification_target

    def initialize
      @notification_channel = "default_notification_channel"
      @notification_target = "notifications-count"
    end
  end
end
