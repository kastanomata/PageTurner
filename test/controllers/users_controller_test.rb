require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @admin = users(:two)
  end

  test "should not get index" do
    get users_path
    assert_response :unauthorized
  end

  test "should get index" do
    post session_path, params: { email_address: @admin.email_address, password: "password" }
    assert_equal @admin.id, session[:user_id]
    get users_path
    assert_response :success
  end

  test "should get new" do
    get new_user_path
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_path, params: { user: { email_address: "example@example.com", password: "password" } }
      user = User.last
      patch user_path(user), params: { user: { nickname: "New Nickname", description: "New Description", birthday: "2000-01-01" } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    get user_path(@user)
    assert_response :success
  end

  test "should get edit" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    get edit_user_path(@user)
    assert_response :success
  end

  test "should update user" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    patch user_path(@user), params: { user: { birthday: "2000-02-02", description: "New Description the return", nickname: "Nickname New" } }
    assert_redirected_to user_path(@user)
  end

  test "should destroy user" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]

    assert_difference("User.count", -1) do
      delete user_path(@user)
    end

    assert_redirected_to root_path
  end
end
