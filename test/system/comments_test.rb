require "application_system_test_case"

class CommentsTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @post = posts(:one)
  end

  # test "visiting the index" do
  #   visit comments_path
  #   assert_selector "h1", text: "Comments"
  # end

  test "should create comment" do
    login_as(@user)
    visit post_path(@post)
    fill_in "Text:", with: "Namooo"
    click_on "Create Comment"

    assert_text "Comment was successfully created"
    assert_current_path post_path(@post)
  end

  # test "should update Comment" do
  #   visit comment_path(@comment)
  #   click_on "Edit this comment", match: :first

  #   click_on "Update Comment"

  #   assert_text "Comment was successfully updated"
  #   click_on "Back"
  # end

  # test "should destroy Comment" do
  #   visit comment_path(@comment)
  #   click_on "Destroy this comment", match: :first

  #   assert_text "Comment was successfully destroyed"
  # end
end
