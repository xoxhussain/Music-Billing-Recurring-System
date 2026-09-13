# frozen_string_literal: true

class Admin::DashboardController < Admin::BaseController
  def index
    @plans_count = Plan.count
    @features_count = Feature.count
    @subscriptions_count = Subscription.count
    @buyers_count = User.buyers.count
  end
end
