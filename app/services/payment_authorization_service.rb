class PaymentAuthorizationService
  def initialize(user)
    @user = user
  end

  def create_setup_intent
    payment_authorization = find_or_build_payment_authorization
    customer = find_or_create_customer(payment_authorization)

    setup_intent = Stripe::SetupIntent.create(
      customer: customer.id,
      payment_method_types: [ "card" ]
    )

    payment_authorization.update!(
      stripe_customer_id: customer.id
    )

    setup_intent
  end

  def confirm_setup_intent(setup_intent_id)
    payment_authorization = @user.payment_authorization
    setup_intent = Stripe::SetupIntent.retrieve(setup_intent_id)

    return false unless valid_customer?(payment_authorization, setup_intent)

    if setup_intent.status == "succeeded"
      payment_authorization.update!(
        stripe_payment_method_id: setup_intent.payment_method,
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
      Stripe::Customer.create(
        email: @user.email,
        name: @user.name
      )
    end
  end

  def valid_customer?(payment_authorization, setup_intent)
    payment_authorization &&
      setup_intent.customer == payment_authorization.stripe_customer_id
  end
end
