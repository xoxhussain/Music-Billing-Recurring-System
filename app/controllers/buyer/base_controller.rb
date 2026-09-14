class Buyer::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :require_buyer

  private

  def require_buyer
    redirect_to root_path, alert: "Access Denied" unless current_user.buyer?
  end
end
