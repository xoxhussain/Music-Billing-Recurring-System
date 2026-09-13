module InvitationAcceptance
  extend ActiveSupport::Concern

  private

  def valid_invitation?
    if @invitation.nil? || @invitation.accepted_at.present?
      redirect_to root_path, alert: t("invitations.accept.invalid")
    elsif @invitation.expires_at.present? && @invitation.expires_at < Time.current
      redirect_to root_path, alert: t("invitations.accept.expired")
    end
  end

  def build_user
    @user = User.new(email: @invitation.email)
  end

  def create_user
    @user = User.new(
      user_params.merge(
        email: @invitation.email,
        role: Role.find_by!(role: "Buyer")
      )
    )

    if @user.save
      @invitation.update!(accepted_at: Time.current)

      redirect_to new_user_session_path,
                  notice: t("invitations.accept.account_created")
    else
      render :accept, status: :unprocessable_entity
    end
  end

  def user_params
    params.expect(user: [:name, :password, :password_confirmation])
  end
end
