# frozen_string_literal: true

Messaging::Engine.routes.draw do
  root to: redirect("/")
  devise_for :users, class_name: "User", module: :devise

  resources :messages
end
