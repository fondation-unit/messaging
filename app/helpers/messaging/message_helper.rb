# frozen_string_literal: true

module Messaging
  module MessageHelper
    def self.user_name(emitter, current_user)
      return "#{emitter&.firstname} #{emitter&.lastname}" if !defined?(current_user) || !current_user.instance_of?(User)

      if current_user.manager? || current_user.admin?
        (emitter.id == current_user.id) ? emitter.institution.name.to_s : "#{emitter&.firstname} #{emitter&.lastname}"
      else
        (emitter.id == current_user.id) ? "#{emitter&.firstname} #{emitter&.lastname}" : emitter.institution.name.to_s
      end
    end

    def self.message_box_class(message, current_user)
      return message.message_class.to_s if message.message_class.present?

      if current_user.manager? || current_user.admin?
        return "emitter__box user" if message.emitter.student?
      end

      return "emitter__box institution" if message.emitter != current_user

      "self__box"
    end
  end
end
