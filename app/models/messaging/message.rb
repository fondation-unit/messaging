# frozen_string_literal: true

module Messaging
  class Message < ApplicationRecord
    attr_accessor :user, :institution, :current_user, :message_class

    belongs_to :user, class_name: Messaging.configuration.user_class.to_s
    belongs_to :institution, class_name: Messaging.configuration.institution_class.to_s
    belongs_to :emitter, class_name: Messaging.configuration.user_class.to_s

    validates :body, presence: true

    before_validation :set_default_values, on: :create
    after_create_commit :update_user_messages_list, only: %i[create]
    after_create_commit :send_notification, only: %i[create]

    scope :user_messages, ->(user_id) { where(user_id: user_id) }

    scope :users_with_messages, ->(institution) {
      User.joins(:messaging_messages)
        .where(institution_id: institution)
        .group(:id)
        .order(created_at: :desc)
    }

    scope :unread_messages_for_user, ->(user) do
      where(read: false, user: user)
    end

    def set_default_values
      self.institution_id ||= user&.institution_id
    end

    def self.mark_user_message_as_read(user)
      unread_messages = unread_messages_for_user(user).includes(:emitter).select { |m| m.user != m.emitter }
      unread_messages.each do |message|
        message.update(read: true, institution: user.institution, user: user)
      end
    end

    def self.own_institution(institution)
      where(institution_id: institution)
    end

    def self.last_message(user_id)
      where(user: user_id).order(created_at: :desc).first
    end

    def self.last_message_date(user_id)
      last_message(user_id).created_at
    end

    def self.last_message_read?(user_id)
      last_message(user_id).read
    end

    private

    def update_user_messages_list
      self.message_class = (emitter.manager? || emitter.admin?) ? "self__box institution" : "emitter__box user"

      broadcast_append_to "message_channel:#{user.id}",
        partial: "messaging/messages/message",
        locals: {message: self},
        target: "messages-list"
    end

    def send_notification
      user.public_send(Messaging.configuration.notification_emitter_method, [user])
    end
  end
end

# == Schema Information
#
# Table name: messaging_messages
#
#  id                :bigint           not null, primary key
#  body              :text(65535)
#  read              :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :bigint
#  institution_id    :bigint
#  emitter_id        :bigint
#
# Indexes
#
#  index_messaging_messages_on_emitter_id      (emitter_id)
#  index_messaging_messages_on_institution_id  (institution_id)
#  index_messaging_messages_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (emitter_id => users.id)
#  fk_rails_...  (institution_id => institutions.id)
#  fk_rails_...  (user_id => users.id)
#
