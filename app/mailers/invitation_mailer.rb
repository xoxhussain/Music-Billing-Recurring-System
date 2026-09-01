class InvitationMailer < ApplicationMailer
  def invitation(invitation)
    @invitation = invitation

    @accept_url = accept_invitation_url(
      token: @invitation.token
    )

    mail(
      to: @invitation.email,
      subject: "You're invited to join our music subscription platform"
    )
  end
end
