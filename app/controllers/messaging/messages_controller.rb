# frozen_string_literal: true

module Messaging
  class MessagesController < ::ApplicationController
    layout "message"

    before_action :authenticate_user!

    def index
      # Non managers only need to see the messaging interface
      return redirect_to new_message_path if !current_user.is_manager?

      # Managers get a list of messages for their institution
      @messages = Message.users_with_messages(current_user&.institution)
      render :index
    end

    def new
      user_id = current_user.is_manager? ? params[:id] : current_user.id
      @user_messages = Message.includes(:emitter).user_messages(user_id)
      Message.mark_user_message_as_read(current_user)

      @message = Message.new
    end

    def create
      @user = User.includes(:institution).find(params[:message][:user_id])
      @message = Message.new(message_params.merge(user: @user, institution: @user.institution, emitter: current_user))

      if @message.save
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.append(
              "messages-list",
              partial: "messaging/messages/message",
              locals: {message: @message}
            )
          end
        end
      else
        redirect_to new_message_path
      end
    end

    private

      def message_params
        params.require(:message).permit(:user_id, :emitter_id, :receiver_id, :emitter_type, :receiver_type, :body)
      end
  end
end
