require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    @other_post = posts(:two)
    @user = users(:one)
  end

  test "should get index" do
    get posts_path
    assert_response :success
  end

  test "should get new" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    get new_post_path
    assert_response :success
  end

  test "should create post" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    assert_difference("Post.count") do
      post posts_path, params: { post: { isbn: "9780618346257", text: "Che mina", title: "Daje Roma" } }
    end

    assert_redirected_to post_path(Post.last)
  end

  test "should create post new book" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    assert_difference("Post.count") do
      post posts_path, params: { post: { isbn: "9788879835886", text: "Che mina", title: "Daje Roma" } }
    end

    assert_redirected_to post_path(Post.last)
  end

  test "should show post" do
    get post_path(@post)
    assert_response :success
  end

  test "should get edit" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    get edit_post_path(@post)
    assert_response :success
  end

  test "should update post" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    patch post_path(@post), params: { post: { text: "Letsgoo", title: "Namooo" } }
    assert_redirected_to post_path(@post)
  end

  test "should destroy post" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    assert_difference("Post.count", -1) do
      delete post_path(@post)
    end

    assert_redirected_to posts_path
  end
end
