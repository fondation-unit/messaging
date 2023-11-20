# frozen_string_literal: true

module Messaging
  class Message < ApplicationRecord
    attr_accessor :user, :institution
    belongs_to :user, class_name: "User"
    belongs_to :institution, class_name: "Institution"
    belongs_to :emitter, class_name: "User"

    validates :body, presence: true

    before_validation :set_default_values, on: :create
    after_create_commit :update_user_messages_list, only: %i[create]
    after_create_commit :update_institution_messages_list, only: %i[create]

    scope :user_messages, ->(user) { where(user_id: user.id) }

    scope :unread_messages_for_user, ->(user) do
      includes(:user).where(read: false, user: user)
    end

    def set_default_values
      self.institution ||= user.institution
    end

    def self.mark_user_message_as_read(user)
      unread_messages = unread_messages_for_user(user).includes(:emitter).select { |m| m.user == m.emitter }
      unread_messages.each do |message|
        message.update(read: true)
      end
    end

    def self.own_institution(institution)
      where(institution_id: institution)
    end

    private

      def update_user_messages_list
        broadcast_append_to "message_channel:#{user.id}",
              partial: "messages/message",
              locals: {message: self},
              target: "messages-list"
      end

      # We also need to update the institution’s manager interface
      def update_institution_messages_list
        Institution.get_managers(institution.id).map { |user|
          broadcast_append_to "message_channel:#{user.id}",
                partial: "messages/message",
                locals: {message: self},
                target: "messages-list"
        }
      end
  end
end
