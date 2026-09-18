Rails.application.routes.draw do
  resource :profile, only: :update

  devise_for :users

  root "home#index"

  resources :plans, only: :index

  resources :subscriptions, only: [ :index, :create ] do
    resources :usage_entries, only: :create
  end

  resources :invitations, only: [ :new, :create ]

  match "/invitations/:token/accept",
        to: "invitations#accept",
        via: [ :get, :post ],
        as: :accept_invitation

  resource :payment_authorization, only: [ :show, :create ] do
    get :confirm
  end

  namespace :admin do
    root "dashboard#index"

    resources :features

    resources :plans do
      resources :plan_features, only: [ :create, :destroy ]
    end

    resources :subscriptions, only: [ :index, :show ]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
