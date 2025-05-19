require "test_helper"

class ClubsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @club = clubs(:one)
    @other_club = clubs(:two)
    @user = users(:three)
  end

  test "should get index" do
    get clubs_path
    assert_response :success
  end

  test "should get new" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    get new_club_path
    assert_response :success
  end

  test "should create club" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    assert_difference("Club.count") do
      post clubs_path, params: { club: { name: "club_test", description: "club_description_test", curator_id: @user.id } }
    end

    assert_redirected_to club_path(Club.last)
  end

  test "should show club" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    get club_path(@club)
    assert_response :success
  end

  test "should get edit" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    get edit_club_path(@club)
    assert_response :success
  end

  test "should update club" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    patch club_path(@club), params: { club: { name: "Letsgooo", description: "Namoooo", curator_id: @club.curator } }
    assert_redirected_to club_path(@club)
  end

  test "should destroy club" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    assert_difference("Club.count", -1) do
      delete club_path(@club)
    end

    assert_redirected_to clubs_path
  end
end
