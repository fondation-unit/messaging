# frozen_string_literal: true

Messaging::Engine.routes.draw do
  root to: redirect("/")
  get "/admin", to: redirect("/admin"), as: :admin_index
  devise_for :users, class_name: "User", module: :devise

  resources :messages, only: %i[index new create]
end
