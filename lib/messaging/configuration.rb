# frozen_string_literal: true

module Messaging
  class Configuration
    attr_accessor :notification_channel

    def initialize
      @notification_channel = "notification_channel"
    end
  end
end
