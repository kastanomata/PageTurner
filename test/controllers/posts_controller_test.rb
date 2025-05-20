require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    @club = clubs(:one)
    @user = users(:one)
    @admin = users(:three)
  end

  test "should not get index as Guest" do
    get posts_path
    assert_response :unauthorized
  end
  test "should not get index as User" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    get posts_path
    assert_response :unauthorized
  end

  test "should get index as Admin" do
    post session_path, params: { email_address: @admin.email_address, password: "password" }
    assert_equal @admin.id, session[:user_id]
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

  test "should report post" do
    post session_path, params: { email_address: @admin.email_address, password: "password" }
    assert_equal @admin.id, session[:user_id]
    assert_difference("Report.count") do
      post reports_path, params: { report: { reporter_id: @admin.id, reported_id: @post.id, reported_type: "Post" } }
    end

    assert_response :success
  end

  test "like post" do
    post session_path, params: { email_address: @admin.email_address, password: "password" }
    assert_equal @admin.id, session[:user_id]
    assert_difference("Like.count") do
      post post_likes_path(@post), params: { like: { user_id: @admin.id, post_id: @post.id } }
    end

    assert_redirected_to post_path(@post)
  end

  test "comment post" do
    post session_path, params: { email_address: @admin.email_address, password: "password" }
    assert_equal @admin.id, session[:user_id]
    assert_difference("Comment.count") do
      post post_comments_path(@post), params: { comment: { author_id: @admin.id, post_id: @post.id, text: "Che mina" } }
    end

    assert_redirected_to post_path(@post)
  end

  test "remove post from club" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_equal @user.id, session[:user_id]
    assert_no_difference("Post.count") do
      delete remove_post_club_path(@post.club_id), params: { post_id: @post.id }
    end

    @post.reload
    assert_nil @post.club_id, "Post should no longer be associated with a club"
    assert_redirected_to club_path(@club)
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
