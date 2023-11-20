# frozen_string_literal: true

module Messaging
  class MessagesController < ::ApplicationController
    layout "application"

    before_action :authenticate_user!

    def index
      @messages = Message.all
      render :index
    end

    def new; end

    def create; end
  end
end
