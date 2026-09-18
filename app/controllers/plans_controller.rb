class PlansController < ApplicationController
  layout "buyer"

  before_action :authenticate_user!
  before_action :require_buyer

  def index
    @plans = Plan.includes(:features).all
  end
end
