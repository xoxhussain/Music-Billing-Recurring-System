Rails.application.routes.draw do
  devise_for :users

  resources :invitations, only: [ :new, :create ]

  match "/invitations/:token/accept",
        to: "invitations#accept",
        via: [ :get, :post ],
        as: :accept_invitation

  root "invitations#new"

  namespace :admin do
    get "features/index"
    get "features/new"
    get "features/edit"
    get "features/show"
    root "dashboard#index"

    resources :features
    resources :plans do
      resources :plan_features, only: [ :create, :destroy ]
    end
    resources :subscriptions, only: [ :index, :show ]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
