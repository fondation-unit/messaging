# frozen_string_literal: true

module Messaging
  class MessagesController < ::ApplicationController
    layout "application"

    before_action :authenticate_user!

    def index
      @messages = Message.all
      render :index
    end

    def show; end

    def new
      @user_messages = Message.includes(:emitter, :user).user_messages(current_user)
      Message.mark_user_message_as_read(current_user)

      @message = Message.new
    end

    def create
      p "*" * 90
      p params
      p "*" * 90
    end


    def update; end

    private

      def message_params
        params.require(:message).permit(:emitter_id, :receiver_id, :emitter_type, :receiver_type, :body)
      end
  end
end
