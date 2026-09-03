class Admin::SubscriptionsController < ApplicationController
  include AdminAuthorization

  layout "admin"

  before_action :set_subscription, only: :show

  def index
    @subscriptions = Subscription.includes(
      :user,
      :plan,
      :subscription_statuses,
      usage_entries: { plan_feature: :feature }
    )
  end

  def show
  end

  private

  def set_subscription
    @subscription = Subscription.includes(
      :user,
      :plan,
      :subscription_statuses,
      usage_entries: { plan_feature: :feature }
    ).find(params[:id])
  end
end
