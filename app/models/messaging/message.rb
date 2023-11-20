# frozen_string_literal: true

module Messaging
  class Message < ApplicationRecord
    table_name = "messaging_messages"

    attr_accessor :user, :institution

    belongs_to :user, class_name: "User"
    belongs_to :institution, class_name: "Institution"
    belongs_to :emitter, class_name: "User"

    validates :body, presence: true

    before_validation :set_default_values, on: :create
    after_create_commit :update_user_messages_list, only: %i[create]
    after_create_commit :update_institution_messages_list, only: %i[create]

    scope :user_messages, ->(user) { where(user_id: user.id) }
    scope :users_with_messages, ->(institution) {
      User.joins(:messaging_messages)
          .where(institution_id: institution)
          .group(:id)
          .order(created_at: :desc)
    }

    scope :unread_messages_for_user, ->(user) do
      includes(:user).where(read: false, user: user)
    end

    def set_default_values
      self.institution_id ||= user&.institution_id
    end

    def self.mark_user_message_as_read(user)
      unread_messages = unread_messages_for_user(user).includes(:emitter).select { |m| m.user == m.emitter }
      unread_messages.each do |message|
        message.update(read: true)
      end
    end

    def self.own_institution(institution)
      includes([:user]).where(institution_id: institution)
    end

    def self.last_message(user_id)
      where(user: user_id).order(created_at: :desc).first
    end
  
    def self.last_message_date(user_id)
      self.last_message(user_id).created_at
    end
  
    def self.last_message_read?(user_id)
      self.last_message(user_id).read
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
