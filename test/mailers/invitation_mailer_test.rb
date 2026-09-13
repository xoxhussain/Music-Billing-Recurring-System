require "test_helper"

class InvitationMailerTest < ActionMailer::TestCase
  test "invitation" do
    invitation = invitations(:pending)
    mail = InvitationMailer.invitation(invitation)

    assert_equal "You're invited to join our music subscription platform", mail.subject
    assert_equal [ invitation.email ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Accept Invitation", mail.body.encoded
  end
end
