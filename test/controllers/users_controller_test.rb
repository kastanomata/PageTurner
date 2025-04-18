require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
<<<<<<< HEAD
    @other_user = users(:two)
=======
    @admin = users(:two)
  end

  test "should not get index" do
    get users_path
    assert_response :unauthorized
>>>>>>> 62a5833
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
<<<<<<< HEAD
    post login_path, params: { session: { email_address: @user.email_address, password: @user.password } }
    get user_url(@user)
=======
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    get user_path(@user)
>>>>>>> 62a5833
    assert_response :success
  end

  test "should get edit" do
<<<<<<< HEAD
    post login_path, params: { session: { email_address: @user.email_address, password: @user.password } }
    get edit_user_url(@user)
=======
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    get edit_user_path(@user)
>>>>>>> 62a5833
    assert_response :success
  end

  test "should update user" do
<<<<<<< HEAD
    post login_path, params: { session: { email_address: @user.email_address, password: @user.password } }
    patch user_url(@user), params: { user: { birthday: @user.birthday, description: @user.description, email_address: @user.email_address, nickname: @user.nickname } }
    assert_redirected_to user_url(@user)
  end

  test "should destroy user" do
    user = User.last
    session[:user_id] = user.id
    assert_difference("User.count", -1) do
      delete user_path(user)
=======
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
>>>>>>> 62a5833
    end

    assert_redirected_to root_path
  end
end
