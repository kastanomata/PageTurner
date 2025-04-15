require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @other_user = users(:two)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
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
    post login_path, params: { session: { email_address: @user.email_address, password: @user.password } }
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    post login_path, params: { session: { email_address: @user.email_address, password: @user.password } }
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    post login_path, params: { session: { email_address: @user.email_address, password: @user.password } }
    patch user_url(@user), params: { user: { birthday: @user.birthday, description: @user.description, email_address: @user.email_address, nickname: @user.nickname } }
    assert_redirected_to user_url(@user)
  end

  test "should destroy user" do
    user = User.last
    session[:user_id] = user.id
    assert_difference("User.count", -1) do
      delete user_path(user)
    end

    assert_redirected_to users_url
  end
end
