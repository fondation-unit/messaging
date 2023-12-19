# frozen_string_literal: true

module Messaging
  class UsersController < ::ApplicationController
    def search
      if params[:search_value].present?
        @users = User.where(
          "firstname LIKE ? OR lastname LIKE ?",
          "%#{params[:search_value]}%",
          "%#{params[:search_value]}%"
        ).where(institution_id: current_user.institution)
      end

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("search_results",
              partial: "messaging/users/search_results",
              locals: {users: @users ||= []})
          ]
        end
      end
    end
  end
end
