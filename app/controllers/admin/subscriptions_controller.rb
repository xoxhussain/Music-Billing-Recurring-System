class Admin::SubscriptionsController < Admin::BaseController
  before_action :set_subscription, only: :show

  def index
    @subscriptions = Subscription.with_details
  end

  def show; end

  private

  def set_subscription
    @subscription = Subscription.with_details.find(params[:id])
  end
end
