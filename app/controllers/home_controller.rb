class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.admin?
      redirect_to admin_root_path
    else
      redirect_to plans_path
    end
  end
end
