Rails.application.routes.draw do
  root 'orders#new'

  resources :orders, only: [:new, :create, :show, :index]

  # ActiveAdmin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Healthcheck
  get "up" => "rails/health#show", as: :rails_health_check
end
