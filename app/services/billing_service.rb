class BillingService
  def initialize(date = Date.current)
    @date = date
  end

  def call
    eligible_users.each do |user|
      charge_user(user)
    end
  end

  private

  def eligible_users
    User
      .where.not(billing_day: nil)
      .select { |user| BillingDateCalculator.new(user.billing_day, @date).due_today? }
  end

  def charge_user(user)
    user.subscriptions.each do |subscription|
      next unless subscription_active?(subscription)

      charge_subscription(user, subscription)
    end
  end

  def subscription_active?(subscription)
    subscription.subscription_statuses.last&.active?
  end

  def charge_subscription(user, subscription)
    RecurringBillingService.new(user, subscription, @date).call
  end
end
