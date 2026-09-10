class SubscriptionsController < ApplicationController
  layout "buyer"

  before_action :authenticate_user!
  before_action :require_buyer

  def index
    @subscriptions = current_user.subscriptions.includes(
      :subscription_statuses,
      plan: { plan_features: :feature },
      usage_entries: { plan_feature: :feature }
    )
  end

  def create
    plan = Plan.find(params[:plan_id])

    subscription = current_user.subscriptions.build(
      plan: plan,
      started_at: Time.current
    )

    if subscription.save
      SubscriptionStatus.create!(
        subscription: subscription,
        status: :active,
        is_using: true
      )

      redirect_to subscriptions_path,
                  notice: "Subscription created successfully"

    else
      redirect_to plans_path,
                  alert: subscription.errors.full_messages.to_sentence

    end
  end
end
