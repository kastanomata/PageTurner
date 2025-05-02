# require "test_helper"

# class CommentsControllerTest < ActionDispatch::IntegrationTest
#   setup do
#     @comment = comments(:one)
#     @other_comment = comments(:two)
#     @user = users(:one)
#   end

#   test "should get index" do
#     get comments_path
#     assert_response :success
#   end

#   test "should get new" do
#     post session_path, params: { email_address: @user.email_address, password: "password" }
#     assert_equal @user.id, session[:user_id]
#     puts comments_path
#     get new_comment_path
#     assert_response :success
#   end

#   test "should create comment" do
#     post session_path, params: { email_address: @user.email_address, password: "password" }
#     assert_equal @user.id, session[:user_id]
#     assert_difference("Comment.count") do
#       post comments_path, params: { comment: {} }
#     end

#     assert_redirected_to comment_path(Comment.last)
#   end

#   test "should show comment" do
#     post session_path, params: { email_address: @user.email_address, password: "password" }
#     assert_equal @user.id, session[:user_id]
#     get comment_path(@comment)
#     assert_response :success
#   end

#   # test "should get edit" do
#   #   get edit_comment_path(@comment)
#   #   assert_response :success
#   # end

#   # test "should update comment" do
#   #   patch comment_path(@comment), params: { comment: {} }
#   #   assert_redirected_to comment_path(@comment)
#   # end

#   # test "should destroy comment" do
#   #   assert_difference("Comment.count", -1) do
#   #     delete comment_path(@comment)
#   #   end

#   #   assert_redirected_to comments_path
#   # end
# end
