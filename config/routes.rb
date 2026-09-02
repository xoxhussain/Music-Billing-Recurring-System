Rails.application.routes.draw do
  devise_for :users

  resources :invitations, only: [ :new, :create ]

  match "/invitations/:token/accept",
        to: "invitations#accept",
        via: [ :get, :post ],
        as: :accept_invitation

  root "invitations#new"

  get "up" => "rails/health#show", as: :rails_health_check
end
