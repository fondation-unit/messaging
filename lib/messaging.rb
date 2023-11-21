require "messaging/version"
require "messaging/configuration"
require "messaging/engine"

module Messaging
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
