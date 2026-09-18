module AdminAuthorization
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :require_admin
  end

  private

  def require_admin
    head :forbidden unless current_user&.admin?
  end
end
