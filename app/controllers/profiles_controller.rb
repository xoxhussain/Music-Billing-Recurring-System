class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def update
    if current_user.update(profile_params)
      current_user.profile_photo.purge if params.dig(:user, :remove_profile_photo) == "1"

      redirect_back fallback_location: root_path, notice: "Profile updated successfully."
    else
      redirect_back fallback_location: root_path, alert: current_user.errors.full_messages.to_sentence
    end
  end

  private

  def profile_params
    params.expect(
      user: [ :name, :about, :interests, :profile_photo ]
    )
  end
end
