# Preview all emails at http://localhost:3000/rails/mailers/invitation_mailer
class InvitationMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/invitation_mailer/invitation
  def invitation
    invitation = Invitation.new(
      email: "preview@example.com",
      token: "preview_token",
      inviter: User.new(name: "Admin", email: "admin@example.com")
    )
    InvitationMailer.invitation(invitation)
  end
end
