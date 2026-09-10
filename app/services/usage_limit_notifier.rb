class UsageLimitNotifier
  def self.call(subscription:, plan_feature:, previous_usage:)
    new(
      subscription: subscription,
      plan_feature: plan_feature,
      previous_usage: previous_usage
    ).call
  end

  def initialize(subscription:, plan_feature:, previous_usage:)
    @subscription = subscription
    @plan_feature = plan_feature
    @previous_usage = previous_usage
  end

  def call
    return unless crossed_limit?

    UsageLimitMailer
      .with(
        subscription: @subscription,
        plan_feature: @plan_feature
      )
      .usage_exceeded
      .deliver_later
  end

  private

  def crossed_limit?
    max_limit.present? &&
      @previous_usage <= max_limit &&
      current_usage > max_limit
  end

  def current_usage
    @subscription.usage_for(@plan_feature)
  end

  def max_limit
    @plan_feature.feature.max_unit_limit
  end
end
