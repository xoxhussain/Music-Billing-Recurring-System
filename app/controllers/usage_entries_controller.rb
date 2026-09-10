class UsageEntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subscription
  before_action :set_plan_feature

  def create
    previous_usage = @subscription.usage_for(@plan_feature)

    @usage_entry = @subscription.usage_entries.build(usage_entry_params)
    @usage_entry.plan_feature = @plan_feature

    if @usage_entry.save
      UsageLimitNotifier.call(
        subscription: @subscription,
        plan_feature: @plan_feature,
        previous_usage: previous_usage
      )

      redirect_to subscriptions_path, notice: "Usage added successfully."
    else
      redirect_to subscriptions_path,
                  alert: @usage_entry.errors.full_messages.to_sentence
    end
  end

  private

  def set_subscription
    @subscription = current_user.subscriptions.find(params[:subscription_id])
  end

  def set_plan_feature
    @plan_feature = @subscription.plan.plan_features.find(
      params.dig(:usage_entry, :plan_feature_id)
    )
  end

  def usage_entry_params
    params.require(:usage_entry).permit(:quantity, :plan_feature_id)
  end
end
