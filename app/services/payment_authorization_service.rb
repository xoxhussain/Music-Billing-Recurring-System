class PaymentAuthorizationService
  def initialize(user)
    @user = user
  end

  def create_payment_setup_intent
    payment_authorization = find_or_build_payment_authorization
    customer = find_or_create_customer(payment_authorization)

    payment_setup_intent = Stripe::SetupIntent.create(
      customer: customer.id,
      payment_method_types: [ "card" ]
    )

    payment_authorization.update!(
      stripe_customer_id: customer.id
    )

    payment_setup_intent
  end

  def confirm_payment_setup_intent(payment_setup_intent_id)
    payment_authorization = @user.payment_authorization
    payment_setup_intent = Stripe::SetupIntent.retrieve(payment_setup_intent_id)

    return false unless valid_customer?(payment_authorization, payment_setup_intent)

    if payment_setup_intent.status == "succeeded"
      payment_authorization.update!(
        stripe_payment_method_id: payment_setup_intent.payment_method,
        authorized: true
      )
      true
    else
      false
    end
  end

  private

  def find_or_build_payment_authorization
    @user.payment_authorization ||
      @user.build_payment_authorization
  end

  def find_or_create_customer(payment_authorization)
    if payment_authorization.stripe_customer_id.present?
      Stripe::Customer.retrieve(payment_authorization.stripe_customer_id)
    else
      Stripe::Customer.create(email: @user.email, name: @user.name)
    end
  end

  def valid_customer?(payment_authorization, payment_setup_intent)
    payment_authorization &&
      payment_setup_intent.customer == payment_authorization.stripe_customer_id
  end
end
