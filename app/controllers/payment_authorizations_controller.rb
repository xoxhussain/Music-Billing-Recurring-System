class PaymentAuthorizationsController < ApplicationController
  layout "buyer"

  before_action :authenticate_user!
  before_action :require_buyer

  def show
    @payment_authorization = current_user.payment_authorization
    @stripe_publishable_key = Rails.application.credentials.dig(:stripe, :publishable_key)
  end

  def create
    setup_intent = PaymentAuthorizationService.new(current_user).create_setup_intent

    render json: { client_secret: setup_intent.client_secret }
  end

  def confirm
    authorized = PaymentAuthorizationService
      .new(current_user)
      .confirm_setup_intent(params[:setup_intent_id])

    if authorized
      redirect_to payment_authorization_path,
                  notice: "Payment authorization completed successfully."
    else
      redirect_to payment_authorization_path,
                  alert: "Payment authorization was not completed."
    end
  end
end
