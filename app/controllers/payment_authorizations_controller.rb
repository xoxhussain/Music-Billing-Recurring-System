class PaymentAuthorizationsController < Buyer::BaseController
  layout "buyer"

  def show
    @payment_authorization = current_user.payment_authorization
    @stripe_publishable_key = Rails.application.credentials.dig(:stripe, :publishable_key)
  end

  def create
    payment_setup_intent = PaymentAuthorizationService.new(current_user).create_payment_setup_intent

    render json: { client_secret: payment_setup_intent.client_secret }
  end

  def confirm
    authorized = PaymentAuthorizationService.new(current_user).confirm_payment_setup_intent(params[:payment_setup_intent_id])

    if authorized
      redirect_to payment_authorization_path,
                  notice: "Payment authorization completed successfully."
    else
      redirect_to payment_authorization_path,
                  alert: "Payment authorization was not completed."
    end
  end
end
