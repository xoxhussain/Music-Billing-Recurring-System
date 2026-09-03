# frozen_string_literal: true

class Admin::DashboardController < ApplicationController
  include AdminAuthorization

  layout "admin"

  def index
    @plans_count = Plan.count
    @features_count = Feature.count
    @subscriptions_count = Subscription.count
    @buyers_count = User.joins(:role).where(roles: { role: "Buyer" }).count
  end
end
