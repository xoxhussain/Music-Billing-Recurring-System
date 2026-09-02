class InvitationsController < ApplicationController
  include InvitationAcceptance

  before_action :authenticate_user!, only: [ :new, :create ]
  before_action :require_admin, only: [ :new, :create ]

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = current_user.sent_invitations.build(invitation_params)

    @invitation.token = SecureRandom.urlsafe_base64
    @invitation.expires_at = 48.hours.from_now

    if @invitation.save
      InvitationMailer.invitation(@invitation).deliver_later
      redirect_to root_path, notice: t("invitations.create.success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def accept
    @invitation = find_invitation
    return unless valid_invitation?

    if request.get?
      build_user
      render :accept
    else
      create_user
    end
  end


  private

  def invitation_params
    params.require(:invitation).permit(:email)
  end

  def require_admin
    redirect_to new_user_session_path, alert: "Unauthorized." unless current_user.admin?
  end
end
