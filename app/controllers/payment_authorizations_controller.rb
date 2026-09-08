class PaymentAuthorizationsController < ApplicationController
  layout "buyer"

  before_action :authenticate_user!
  before_action :require_buyer

  def show
    @payment_authorization = current_user.payment_authorization
    @stripe_publishable_key = Rails.application.credentials.dig(:stripe, :publishable_key)
  end

  def create
    payment_authorization =
      current_user.payment_authorization ||
      current_user.build_payment_authorization

    customer =
      if payment_authorization.stripe_customer_id.present?
        Stripe::Customer.retrieve(payment_authorization.stripe_customer_id)
      else
        Stripe::Customer.create(
          email: current_user.email,
          name: current_user.name
        )
      end

    setup_intent = Stripe::SetupIntent.create(
      customer: customer.id,
      payment_method_types: [ "card" ]
    )

    payment_authorization.update!(
      stripe_customer_id: customer.id,
    )

    render json: { client_secret: setup_intent.client_secret }
  end

  def confirm
    payment_authorization = current_user.payment_authorization

    setup_intent = Stripe::SetupIntent.retrieve(params[:setup_intent_id])

    unless payment_authorization &&
           setup_intent.customer == payment_authorization.stripe_customer_id
      redirect_to payment_authorization_path,
                  alert: "Invalid payment authorization."
      return
    end

    if setup_intent.status == "succeeded"
      payment_authorization.update!(
        stripe_payment_method_id: setup_intent.payment_method,
        authorized: true
      )

      redirect_to payment_authorization_path,
                  notice: "Payment authorization completed successfully."
    else
      redirect_to payment_authorization_path,
                  alert: "Payment authorization was not completed."
    end
  end
end
