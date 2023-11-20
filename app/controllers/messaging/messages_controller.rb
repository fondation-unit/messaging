# frozen_string_literal: true

module Messaging
  class MessagesController < ::ApplicationController
    layout "application"

    before_action :authenticate_user!

    def index
      @messages = Message.all
      render :index
    end

    def new
      @user_messages = Message.includes(:emitter, :user).user_messages(current_user)
      Message.mark_user_message_as_read(current_user)

      @message = Message.new
    end

    def create; end
  end
end
