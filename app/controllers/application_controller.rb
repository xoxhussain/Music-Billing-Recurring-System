class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  stale_when_importmap_changes

  private

  def require_buyer
    redirect_to root_path, alert: "Access Denied" unless current_user.buyer?
  end
end
