module Messaging
  module MessageHelper
    def self.user_name(firstname, lastname)
      "#{firstname} #{lastname}"
    end

    def self.message_box_class(message, current_user)
      return "self" if message.emitter_id != message.user_id && current_user.is_manager?

      return "self" if message.emitter_id == message.user_id && !current_user.is_manager?
      
      "emitter"
    end
  end
end
