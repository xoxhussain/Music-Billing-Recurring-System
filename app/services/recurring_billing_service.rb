class RecurringBillingService
  def initialize(user, subscription, date = Date.current)
    @user = user
    @subscription = subscription
    @date = date
  end

  def call
    return false if already_billed?

    amount = @subscription.plan.monthly_fee

    payment_intent = Stripe::PaymentIntent.create(
      amount: amount_in_cents(amount),
      currency: "usd",
      customer: payment_authorization.stripe_customer_id,
      payment_method: payment_authorization.stripe_payment_method_id,
      off_session: true,
      confirm: true
    )

    create_transaction(
      amount: amount,
      status: :successful,
      stripe_payment_id: payment_intent.id
    )

    true
  rescue Stripe::CardError => e
    create_transaction(
      amount: amount,
      status: :failed,
      stripe_payment_id: e.payment_intent&.id
    )

    halt_subscription

    false
  rescue Stripe::StripeError
    create_transaction(
      amount: amount,
      status: :failed,
      stripe_payment_id: nil
    )

    halt_subscription

    false
  rescue StandardError => e
    Rails.logger.error("Recurring billing failed: #{e.class}: #{e.message}")
    false
  end

  private

  def already_billed?
    @subscription.transactions
      .where(transaction_type: "recurring")
      .where(occurred_at: @date.beginning_of_day..@date.end_of_day)
      .exists?
  end

  def payment_authorization
    @user.payment_authorization
  end

  def amount_in_cents(amount)
    (amount.to_d * 100).round
  end

  def create_transaction(amount:, status:, stripe_payment_id:)
    @user.transactions.create!(
      subscription: @subscription,
      amount: amount,
      status: status,
      transaction_type: "recurring",
      stripe_payment_id: stripe_payment_id,
      occurred_at: Time.current
    )
  end

  def halt_subscription
    @subscription.subscription_statuses.create!(
      status: :halted,
      is_using: false
    )
  end
end
