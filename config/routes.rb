# frozen_string_literal: true

Messaging::Engine.routes.draw do
  root to: redirect("/")
  get "/#{Messaging.configuration.admin_path}", to: redirect("/#{Messaging.configuration.admin_path}"), as: :admin_index
  devise_for :users, class_name: Messaging.configuration.user_class, module: :devise

  resources :messages, only: %i[index new create]

  resources :users do
    collection do
      post :search
    end
  end
end
