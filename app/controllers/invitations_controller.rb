class InvitationsController < ApplicationController
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

      redirect_to root_path,
                  notice: "Invitation sent successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def accept
    @invitation = Invitation.find_by(token: params[:token])

    if @invitation.nil? || @invitation.accepted_at.present?
      redirect_to root_path, alert: "Invalid invitation."
      return
    end

    if @invitation.expires_at.present? && @invitation.expires_at < Time.current
      redirect_to root_path, alert: "Invitation has expired."
      return
    end

    unless request.post?
      @user = User.new(email: @invitation.email)
      render :accept
      return
    end

    @user = User.new(
      email: @invitation.email,
      name: params[:user][:name],
      password: params[:user][:password],
      password_confirmation: params[:user][:password_confirmation],
      role: Role.find_by!(role: "Buyer")
    )

    if @user.save
      @invitation.update!(accepted_at: Time.current)

      redirect_to new_user_session_path,
                  notice: "Account created successfully. You can now sign in."
    else
      render :accept, status: :unprocessable_entity
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:email)
  end

  def require_admin
    redirect_to root_path, alert: "Unauthorized." unless current_user.admin?
  end
end
