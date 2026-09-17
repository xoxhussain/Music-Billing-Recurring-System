class PlansController < Buyer::BaseController
  layout "buyer"

  def index
    @plans = Plan.includes(:features).all
  end
end
