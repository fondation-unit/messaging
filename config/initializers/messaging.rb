# frozen_string_literal: true

Messaging.configure do |config|
  config.notification_channel = "notification_channel"
  config.notification_target = "notifications-count"
  config.notification_count_method = "unread_notifications_count"
  config.user_class = "User"
  config.institution_class = "Institution"
end
