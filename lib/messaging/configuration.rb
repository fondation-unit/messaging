# frozen_string_literal: true

module Messaging
  class Configuration
    mattr_accessor :notification_channel, :notification_target, :notification_count_method

    def initialize
      @notification_channel = "default_notification_channel"
      @notification_target = "notifications-count"
      @notification_count_method = nil
    end
  end
end
