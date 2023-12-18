# frozen_string_literal: true

module Messaging
  module MessageHelper
    def self.user_name(firstname, lastname)
      "#{firstname} #{lastname}"
    end

    def self.message_box_class(message, current_user)
      return "#{message.message_class}" if message.message_class.present?

      if current_user.manager? || current_user.admin?
        return "emitter__box user" if message.emitter.student?
      end
      return "emitter__box institution" if message.emitter != current_user

      "self__box"
    end
  end
end
