require "test_helper"

class InvitationsControllerTest < ActionDispatch::IntegrationTest
  test "should redirect new when not signed in" do
    get new_invitation_path
    assert_redirected_to new_user_session_path
  end

  test "should get new when signed in as admin" do
    sign_in users(:admin)
    get new_invitation_path
    assert_response :success
  end

  test "should create invitation when signed in as admin" do
    sign_in users(:admin)

    assert_difference "Invitation.count", 1 do
      post invitations_path, params: { invitation: { email: "newuser@example.com" } }
    end

    assert_redirected_to root_path
  end

  test "should redirect accept when token is invalid" do
    get accept_invitation_path(token: "invalid")
    assert_redirected_to root_path
  end

  test "should get accept when token is valid" do
    invitation = invitations(:pending)
    get accept_invitation_path(token: invitation.token)
    assert_response :success
  end
end
